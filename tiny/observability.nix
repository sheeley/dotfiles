_: {
  networking.firewall.allowedTCPPorts = [
    # loki
    3100
    # prometheus
    9001
  ];

  services.loki = {
    enable = true;
    configFile = ./loki.yaml;
  };

  services.prometheus = {
    enable = true;
    port = 9001;
    globalConfig.scrape_interval = "10s"; # "1m"
    extraFlags = [
      "--log.level=debug"
      "--web.enable-remote-write-receiver"
    ];
    scrapeConfigs = [
      {
        job_name = "unifi";
        static_configs = [
          {
            targets = ["localhost:9130"];
            # targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
      {
        job_name = "pve";
        static_configs = [
          {
            targets = ["proxmox-metrics.sheeley.house:9221"];
            labels = {
              __metrics_path__ = "pve";
              __param_target = "proxmox.sheeley.house";
              __param_cluster = "1";
            };
          }
        ];
      }
    ];

    exporters = {
      unpoller = {
        enable = true;
        user = "sheeley";

        # log.prometheusErrors = true;

        controllers = [
          {
            url = "https://172.20.1.1";
            user = "prom";
            pass = /home/sheeley/.unifiPass;

            verify_ssl = false;
            save_events = true;
            save_alarms = true;
          }
        ];
      };

      node = {
        enable = true;
        port = 9000;
        # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
        enabledCollectors = ["systemd"];

        # /nix/store/zgsw0yx18v10xa58psanfabmg95nl2bb-node_exporter-1.8.1/bin/node_exporter  --help
        extraFlags = ["--collector.ethtool" "--collector.softirqs" "--collector.tcpstat" "--collector.wifi"];
      };
    };
  };

  services.alloy = {
    enable = true;
    configPath = ./alloy.conf;
  };

  # Inkplate
  virtualisation.containers.enable = true;
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
