{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../nixos-common.nix
    ../programs/nix-cache.nix
    # ./coredns.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "tiny"; # Define your hostname.
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.firewall.allowedTCPPorts = [
    # loki
    3100
    # prometheus
    9001
  ];
  networking.firewall.allowedUDPPorts = [53];

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
        job_name = "un";
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
            targets = ["172.20.1.245:9221"];
            labels = {
              __metrics_path__ = "pve";
              __param_target = "172.20.1.178";
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
}
