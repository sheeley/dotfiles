{
  config,
  lib,
  pkgs,
  ...
}: let
  # SSH health metrics exporter
  sshHealthScript = pkgs.writeShellScript "ssh-health-metrics" ''
    # HELP ssh_service_active SSH service status
    # TYPE ssh_service_active gauge
    ${pkgs.systemd}/bin/systemctl is-active ssh >/dev/null 2>&1 && echo "ssh_service_active 1" || echo "ssh_service_active 0"

    # HELP ssh_port_listening SSH port listening status
    # TYPE ssh_port_listening gauge
    ${pkgs.iproute2}/bin/ss -tln | ${pkgs.gnugrep}/bin/grep -q ':22 ' && echo "ssh_port_listening 1" || echo "ssh_port_listening 0"

    # HELP ssh_active_connections Active SSH connections
    # TYPE ssh_active_connections gauge
    echo "ssh_active_connections $(${pkgs.iproute2}/bin/ss -tn | ${pkgs.gnugrep}/bin/grep -c ':22.*ESTABLISHED' || echo 0)"

    # HELP network_gateway_reachable Gateway reachability
    # TYPE network_gateway_reachable gauge
    GATEWAY=$(${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep default | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.coreutils}/bin/head -n1)
    ${pkgs.iputils}/bin/ping -c 1 -W 2 "$GATEWAY" >/dev/null 2>&1 && echo "network_gateway_reachable 1" || echo "network_gateway_reachable 0"

    # HELP dns_resolution_working DNS resolution test
    # TYPE dns_resolution_working gauge
    ${pkgs.dnsutils}/bin/nslookup google.com >/dev/null 2>&1 && echo "dns_resolution_working 1" || echo "dns_resolution_working 0"
  '';

  # Proxmox health metrics exporter
  proxmoxHealthScript = pkgs.writeShellScript "proxmox-health-metrics" ''
    # HELP proxmox_vm_count Number of running VMs
    # TYPE proxmox_vm_count gauge
    echo "proxmox_vm_count $(qm list 2>/dev/null | ${pkgs.gnugrep}/bin/grep -c running || echo 0)"

    # HELP proxmox_container_count Number of running containers
    # TYPE proxmox_container_count gauge
    echo "proxmox_container_count $(pct list 2>/dev/null | ${pkgs.gnugrep}/bin/grep -c running || echo 0)"

    # HELP proxmox_zfs_health ZFS pool health
    # TYPE proxmox_zfs_health gauge
    ${pkgs.zfs}/bin/zpool status rpool 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "state: ONLINE" && echo "proxmox_zfs_health 1" || echo "proxmox_zfs_health 0"

    # HELP system_memory_pressure Memory usage percentage
    # TYPE system_memory_pressure gauge
    TOTAL=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $2}')
    USED=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $3}')
    echo "system_memory_pressure $(( (USED * 100) / TOTAL ))"

    # HELP system_uptime_seconds System uptime
    # TYPE system_uptime_seconds counter
    echo "system_uptime_seconds $(${pkgs.coreutils}/bin/cat /proc/uptime | ${pkgs.gawk}/bin/awk '{print int($1)}')"

    # HELP proxmox_service_active Proxmox services status
    # TYPE proxmox_service_active gauge
    for service in pvedaemon pveproxy pvestatd; do
      ${pkgs.systemd}/bin/systemctl is-active "$service" >/dev/null 2>&1 && echo "proxmox_service_active{service=\"$service\"} 1" || echo "proxmox_service_active{service=\"$service\"} 0"
    done

    # HELP proxmox_vm_status VM status by ID
    # TYPE proxmox_vm_status gauge
    qm list 2>/dev/null | ${pkgs.gawk}/bin/awk 'NR>1 {status=($3=="running"?1:0); print "proxmox_vm_status{vmid=\""$1"\",name=\""$2"\"} " status}'

    # HELP proxmox_container_status Container status by ID
    # TYPE proxmox_container_status gauge
    pct list 2>/dev/null | ${pkgs.gawk}/bin/awk 'NR>1 {status=($2=="running"?1:0); print "proxmox_container_status{ctid=\""$1"\",name=\""$3"\"} " status}'

    # HELP proxmox_storage_usage Storage usage by mount
    # TYPE proxmox_storage_usage gauge
    ${pkgs.coreutils}/bin/df -h | ${pkgs.gawk}/bin/awk 'NR>1 && $6!="/dev" && $6!="/proc" && $6!="/sys" {gsub(/%/, "", $5); print "proxmox_storage_usage{mount=\""$6"\",device=\""$1"\"} " $5}'

    # HELP proxmox_network_interface_up Network interface status
    # TYPE proxmox_network_interface_up gauge
    for iface in vmbr0 eno2; do
      ${pkgs.iproute2}/bin/ip link show "$iface" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "state UP" && echo "proxmox_network_interface_up{interface=\"$iface\"} 1" || echo "proxmox_network_interface_up{interface=\"$iface\"} 0"
    done
  '';
in {
  imports = [
    ../shared/observability # Import shared observability
  ];

  networking.hostName = "proxmox";

  # Observability configuration - Collector role (ships to tiny)
  services.observability = {
    enable = true;
    role = "collector"; # Ships data to central server
    hostName = "proxmox";

    # Custom exporters specific to Proxmox
    customExporters = {
      ssh_health = sshHealthScript;
      proxmox_health = proxmoxHealthScript;
    };

    # Don't run local services - ship to tiny instead
    loki = {
      enable = false; # Don't run Loki locally
      remoteUrl = "http://tiny.sheeley.house:3100"; # Ship to tiny
    };

    prometheus = {
      enable = false; # Don't run Prometheus locally
      remoteWriteUrl = "http://tiny.sheeley.house:9001"; # Ship to tiny
      scrapeInterval = "15s";
    };

    alloy = {
      enable = true; # Run Alloy to collect and ship data
    };
  };

  # SSH health monitoring timer
  systemd.services.ssh-health-logger = {
    description = "SSH Health Monitoring Logger";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "ssh-health-logger" ''
        # Log SSH health events to journal with structured data
        if ! ${pkgs.systemd}/bin/systemctl is-active ssh >/dev/null 2>&1; then
          ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p err echo "SSH service is not active"
        fi

        if ! ${pkgs.iproute2}/bin/ss -tln | ${pkgs.gnugrep}/bin/grep -q ':22 '; then
          ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p err echo "SSH port 22 is not listening"
        fi

        # Test SSH connectivity
        if ! ${pkgs.openssh}/bin/ssh -o ConnectTimeout=3 -o BatchMode=yes -o StrictHostKeyChecking=no localhost true 2>/dev/null; then
          ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p warning echo "SSH internal connectivity test failed"
        fi

        # Memory pressure check
        TOTAL=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $2}')
        USED=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $3}')
        PRESSURE=$(( (USED * 100) / TOTAL ))

        if [ "$PRESSURE" -gt 90 ]; then
          ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p warning echo "High memory pressure: ''${PRESSURE}%"
        fi

        # Check for network issues
        GATEWAY=$(${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep default | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.coreutils}/bin/head -n1)
        if ! ${pkgs.iputils}/bin/ping -c 1 -W 2 "$GATEWAY" >/dev/null 2>&1; then
          ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p err echo "Gateway $GATEWAY unreachable"
        fi
      '';
    };
  };

  systemd.timers.ssh = {
    config,
    lib,
    pkgs,
    ...
  }: let
    # SSH health metrics exporter
    sshHealthScript = pkgs.writeShellScript "ssh-health-metrics" ''
      # HELP ssh_service_active SSH service status
      # TYPE ssh_service_active gauge
      ${pkgs.systemd}/bin/systemctl is-active ssh >/dev/null 2>&1 && echo "ssh_service_active 1" || echo "ssh_service_active 0"

      # HELP ssh_port_listening SSH port listening status
      # TYPE ssh_port_listening gauge
      ${pkgs.iproute2}/bin/ss -tln | ${pkgs.gnugrep}/bin/grep -q ':22 ' && echo "ssh_port_listening 1" || echo "ssh_port_listening 0"

      # HELP ssh_active_connections Active SSH connections
      # TYPE ssh_active_connections gauge
      echo "ssh_active_connections $(${pkgs.iproute2}/bin/ss -tn | ${pkgs.gnugrep}/bin/grep -c ':22.*ESTABLISHED' || echo 0)"

      # HELP network_gateway_reachable Gateway reachability
      # TYPE network_gateway_reachable gauge
      GATEWAY=$(${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep default | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.coreutils}/bin/head -n1)
      ${pkgs.iputils}/bin/ping -c 1 -W 2 "$GATEWAY" >/dev/null 2>&1 && echo "network_gateway_reachable 1" || echo "network_gateway_reachable 0"

      # HELP dns_resolution_working DNS resolution test
      # TYPE dns_resolution_working gauge
      ${pkgs.dnsutils}/bin/nslookup google.com >/dev/null 2>&1 && echo "dns_resolution_working 1" || echo "dns_resolution_working 0"
    '';

    # Proxmox health metrics exporter
    proxmoxHealthScript = pkgs.writeShellScript "proxmox-health-metrics" ''
      # HELP proxmox_vm_count Number of running VMs
      # TYPE proxmox_vm_count gauge
      echo "proxmox_vm_count $(qm list 2>/dev/null | ${pkgs.gnugrep}/bin/grep -c running || echo 0)"

      # HELP proxmox_container_count Number of running containers
      # TYPE proxmox_container_count gauge
      echo "proxmox_container_count $(pct list 2>/dev/null | ${pkgs.gnugrep}/bin/grep -c running || echo 0)"

      # HELP proxmox_zfs_health ZFS pool health
      # TYPE proxmox_zfs_health gauge
      ${pkgs.zfs}/bin/zpool status rpool 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "state: ONLINE" && echo "proxmox_zfs_health 1" || echo "proxmox_zfs_health 0"

      # HELP system_memory_pressure Memory usage percentage
      # TYPE system_memory_pressure gauge
      TOTAL=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $2}')
      USED=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $3}')
      echo "system_memory_pressure $(( (USED * 100) / TOTAL ))"

      # HELP system_uptime_seconds System uptime
      # TYPE system_uptime_seconds counter
      echo "system_uptime_seconds $(${pkgs.coreutils}/bin/cat /proc/uptime | ${pkgs.gawk}/bin/awk '{print int($1)}')"

      # HELP proxmox_service_active Proxmox services status
      # TYPE proxmox_service_active gauge
      for service in pvedaemon pveproxy pvestatd; do
        ${pkgs.systemd}/bin/systemctl is-active "$service" >/dev/null 2>&1 && echo "proxmox_service_active{service=\"$service\"} 1" || echo "proxmox_service_active{service=\"$service\"} 0"
      done

      # HELP proxmox_vm_status VM status by ID
      # TYPE proxmox_vm_status gauge
      qm list 2>/dev/null | ${pkgs.gawk}/bin/awk 'NR>1 {status=($3=="running"?1:0); print "proxmox_vm_status{vmid=\""$1"\",name=\""$2"\"} " status}'

      # HELP proxmox_container_status Container status by ID
      # TYPE proxmox_container_status gauge
      pct list 2>/dev/null | ${pkgs.gawk}/bin/awk 'NR>1 {status=($2=="running"?1:0); print "proxmox_container_status{ctid=\""$1"\",name=\""$3"\"} " status}'

      # HELP proxmox_storage_usage Storage usage by mount
      # TYPE proxmox_storage_usage gauge
      ${pkgs.coreutils}/bin/df -h | ${pkgs.gawk}/bin/awk 'NR>1 && $6!="/dev" && $6!="/proc" && $6!="/sys" {gsub(/%/, "", $5); print "proxmox_storage_usage{mount=\""$6"\",device=\""$1"\"} " $5}'

      # HELP proxmox_network_interface_up Network interface status
      # TYPE proxmox_network_interface_up gauge
      for iface in vmbr0 eno2; do
        ${pkgs.iproute2}/bin/ip link show "$iface" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "state UP" && echo "proxmox_network_interface_up{interface=\"$iface\"} 1" || echo "proxmox_network_interface_up{interface=\"$iface\"} 0"
      done
    '';
  in {
    imports = [
      ../shared/observability # Import shared observability
    ];

    networking.hostName = "proxmox";

    # Observability configuration - Collector role (ships to tiny)
    services.observability = {
      enable = true;
      role = "collector"; # Ships data to central server
      hostName = "proxmox";

      # Custom exporters specific to Proxmox
      customExporters = {
        ssh_health = sshHealthScript;
        proxmox_health = proxmoxHealthScript;
      };

      # Don't run local services - ship to tiny instead
      loki = {
        enable = false; # Don't run Loki locally
        remoteUrl = "http://tiny.sheeley.house:3100"; # Ship to tiny
      };

      prometheus = {
        enable = false; # Don't run Prometheus locally
        remoteWriteUrl = "http://tiny.sheeley.house:9001"; # Ship to tiny
        scrapeInterval = "15s";
      };

      alloy = {
        enable = true; # Run Alloy to collect and ship data
      };
    };

    # SSH health monitoring timer
    systemd.services.ssh-health-logger = {
      description = "SSH Health Monitoring Logger";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "ssh-health-logger" ''
          # Log SSH health events to journal with structured data
          if ! ${pkgs.systemd}/bin/systemctl is-active ssh >/dev/null 2>&1; then
            ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p err echo "SSH service is not active"
          fi

          if ! ${pkgs.iproute2}/bin/ss -tln | ${pkgs.gnugrep}/bin/grep -q ':22 '; then
            ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p err echo "SSH port 22 is not listening"
          fi

          # Test SSH connectivity
          if ! ${pkgs.openssh}/bin/ssh -o ConnectTimeout=3 -o BatchMode=yes -o StrictHostKeyChecking=no localhost true 2>/dev/null; then
            ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p warning echo "SSH internal connectivity test failed"
          fi

          # Memory pressure check
          TOTAL=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $2}')
          USED=$(${pkgs.procps}/bin/free -m | ${pkgs.gawk}/bin/awk 'NR==2{print $3}')
          PRESSURE=$(( (USED * 100) / TOTAL ))

          if [ "$PRESSURE" -gt 90 ]; then
            ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p warning echo "High memory pressure: ''${PRESSURE}%"
          fi

          # Check for network issues
          GATEWAY=$(${pkgs.iproute2}/bin/ip route | ${pkgs.gnugrep}/bin/grep default | ${pkgs.gawk}/bin/awk '{print $3}' | ${pkgs.coreutils}/bin/head -n1)
          if ! ${pkgs.iputils}/bin/ping -c 1 -W 2 "$GATEWAY" >/dev/null 2>&1; then
            ${pkgs.systemd}/bin/systemd-cat -t ssh-health-monitor -p err echo "Gateway $GATEWAY unreachable"
          fi
        '';
      };
    };

    systemd.timers.ssh-health-logger = {
      description = "SSH Health Monitoring Timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*:0/5"; # Every 5 minutes
        Persistent = true;
      };
    };

    # Proxmox health monitoring timer
    systemd.services.proxmox-health-logger = {
      description = "Proxmox Health Monitoring Logger";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "proxmox-health-logger" ''
          # Log Proxmox-specific health events
          VM_COUNT=$(qm list 2>/dev/null | ${pkgs.gnugrep}/bin/grep -c running || echo 0)
          CT_COUNT=$(pct list 2>/dev/null | ${pkgs.gnugrep}/bin/grep -c running || echo 0)

          ${pkgs.systemd}/bin/systemd-cat -t proxmox-health-monitor echo "VMs running: $VM_COUNT, Containers running: $CT_COUNT"

          # Check ZFS health
          if ! ${pkgs.zfs}/bin/zpool status rpool 2>/dev/null | ${pkgs.gnugrep}/bin/grep -q "state: ONLINE"; then
            ${pkgs.systemd}/bin/systemd-cat -t proxmox-health-monitor -p err echo "ZFS pool rpool is not ONLINE"
          fi

          # Check PVE services
          SERVICES="pvedaemon pveproxy pvestatd"
          for service in $SERVICES; do
            if ! ${pkgs.systemd}/bin/systemctl is-active "$service" >/dev/null 2>&1; then
              ${pkgs.systemd}/bin/systemd-cat -t proxmox-health-monitor -p err echo "Proxmox service $service is not active"
            fi
          done
        '';
      };
    };

    systemd.timers.proxmox-health-logger = {
      description = "Proxmox Health Monitoring Timer";
      wantedBy = ["timers.target"];
      timerConfig = {
        OnCalendar = "*:0/10"; # Every 10 minutes
        Persistent = true;
      };
    };
  };

  # Enable copyq clipboard manager
  services.copyq.enable = true;
}
