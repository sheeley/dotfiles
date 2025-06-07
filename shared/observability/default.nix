# shared/observability/default.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.observability;

  # Generate Alloy configuration as a Nix string
  alloyConfig = ''
    // Alloy configuration for ${cfg.hostName} (role: ${cfg.role})

    // Log collection from systemd journal
    discovery.relabel "journal" {
        targets = []
        rule {
            source_labels = ["__journal__systemd_unit"]
            target_label  = "unit"
        }
    }

    loki.source.journal "journal" {
        max_age       = "12h0m0s"
        relabel_rules = discovery.relabel.journal.rules
        forward_to    = [${
      if cfg.loki.remoteUrl != null
      then "loki.write.remote.receiver"
      else "loki.write.local.receiver"
    }]
        labels        = {
            host = "${cfg.hostName}",
            job  = "systemd-journal",
        }
    }

    ${optionalString (cfg.loki.remoteUrl != null) ''
      loki.write "remote" {
          endpoint {
              url = "${cfg.loki.remoteUrl}/loki/api/v1/push"
          }
          external_labels = { host = "${cfg.hostName}" }
      }
    ''}

    ${optionalString (cfg.loki.remoteUrl == null) ''
      loki.write "local" {
          endpoint {
              url = "http://127.0.0.1:${toString cfg.loki.port}/loki/api/v1/push"
          }
          external_labels = { host = "${cfg.hostName}" }
      }
    ''}

    // Node exporter metrics
    prometheus.exporter.unix "default" {
      include_exporter_metrics = true
      disable_collectors       = ["mdadm"]
    }

    prometheus.scrape "unix" {
      targets    = prometheus.exporter.unix.default.targets
      forward_to = [${
      if cfg.prometheus.remoteWriteUrl != null
      then "prometheus.remote_write.remote.receiver"
      else "prometheus.remote_write.local.receiver"
    }]
      job_name   = "${cfg.hostName}-node"
      scrape_interval = "${cfg.prometheus.scrapeInterval}"
    }

    ${concatStringsSep "\n" (mapAttrsToList (name: script: ''
        // Custom exporter: ${name}
        prometheus.exporter.script "${name}" {
          command = "${script}"
          timeout = "30s"
        }

        prometheus.scrape "${name}" {
          targets    = prometheus.exporter.script.${name}.targets
          forward_to = [${
          if cfg.prometheus.remoteWriteUrl != null
          then "prometheus.remote_write.remote.receiver"
          else "prometheus.remote_write.local.receiver"
        }]
          job_name   = "${cfg.hostName}-${name}"
          scrape_interval = "60s"
        }
      '')
      cfg.customExporters)}

    ${optionalString (cfg.prometheus.remoteWriteUrl != null) ''
      prometheus.remote_write "remote" {
        endpoint {
          url = "${cfg.prometheus.remoteWriteUrl}/api/v1/write"
        }
        external_labels = { host = "${cfg.hostName}" }
      }
    ''}

    ${optionalString (cfg.prometheus.remoteWriteUrl == null) ''
      prometheus.remote_write "local" {
        endpoint {
          url = "http://127.0.0.1:${toString cfg.prometheus.port}/api/v1/write"
        }
        external_labels = { host = "${cfg.hostName}" }
      }
    ''}
  '';

  alloyConfigFile = pkgs.writeText "alloy.conf" alloyConfig;
in {
  options.services.observability = {
    enable = mkEnableOption "observability stack";

    role = mkOption {
      type = types.enum ["server" "collector" "standalone"];
      default = "standalone";
      description = "Role: server (central), collector (ships data), standalone (local)";
    };

    hostName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "Hostname for labeling";
    };

    loki = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Loki service";
      };

      port = mkOption {
        type = types.port;
        default = 3100;
        description = "Loki port";
      };

      remoteUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Remote Loki URL (for collector role)";
      };
    };

    prometheus = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Prometheus service";
      };

      port = mkOption {
        type = types.port;
        default = 9001;
        description = "Prometheus port";
      };

      remoteWriteUrl = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Remote Prometheus URL (for collector role)";
      };

      scrapeInterval = mkOption {
        type = types.str;
        default = "15s";
        description = "Scrape interval";
      };
    };

    alloy = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Alloy";
      };
    };

    customExporters = mkOption {
      type = types.attrsOf types.path;
      default = {};
      description = "Custom exporter scripts as name -> path mapping";
    };
  };

  config = mkIf cfg.enable {
    # Loki service (only if role is server or standalone)
    services.loki = mkIf (cfg.loki.enable && (cfg.role == "server" || cfg.role == "standalone")) {
      enable = true;
      configFile = pkgs.writeText "loki.yaml" (builtins.toJSON {
        auth_enabled = false;
        server = {
          http_listen_port = cfg.loki.port;
          grpc_listen_port = 0;
        };
        common = {
          instance_addr = "127.0.0.1";
          path_prefix = "/var/lib/loki";
          storage.filesystem = {
            chunks_directory = "/var/lib/loki/chunks";
            rules_directory = "/var/lib/loki/rules";
          };
          replication_factor = 1;
          ring.kvstore.store = "inmemory";
        };
        schema_config.configs = [
          {
            from = "2020-10-24";
            store = "boltdb-shipper";
            object_store = "filesystem";
            schema = "v11";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
        limits_config.retention_period = "168h";
      });
    };

    # Prometheus service (only if role is server or standalone)
    services.prometheus = mkIf (cfg.prometheus.enable && (cfg.role == "server" || cfg.role == "standalone")) {
      enable = true;
      inherit (cfg.prometheus) port;
      globalConfig.scrape_interval = cfg.prometheus.scrapeInterval;
      extraFlags = [
        "--web.enable-remote-write-receiver"
        "--storage.tsdb.retention.time=30d"
      ];

      exporters.node = {
        enable = true;
        enabledCollectors = ["systemd" "processes"];
        extraFlags = ["--collector.ethtool" "--collector.tcpstat"];
      };

      scrapeConfigs = mkIf (cfg.role == "server") [
        {
          job_name = "prometheus";
          static_configs = [{targets = ["localhost:${toString cfg.prometheus.port}"];}];
        }
        {
          job_name = "node";
          static_configs = [{targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];}];
        }
      ];
    };

    # Alloy service
    services.alloy = mkIf cfg.alloy.enable {
      enable = true;
      configPath = alloyConfigFile;
    };

    # Firewall
    networking.firewall.allowedTCPPorts =
      (optional (cfg.loki.enable && (cfg.role == "server" || cfg.role == "standalone")) cfg.loki.port)
      ++ (optional (cfg.prometheus.enable && (cfg.role == "server" || cfg.role == "standalone")) cfg.prometheus.port);

    # Required packages
    environment.systemPackages = with pkgs; [
      bc
      inetutils
      smartmontools
    ];
  };
}
