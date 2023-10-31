{ config, pkgs, ... }:

{
  systemd = {
    nspawn = (builtins.mapAttrs (name: value: {
      filesConfig.Bind = [ "/dev/dri" ];
      networkConfig.Private = false;
    }) {
      archriscv = {};
      old-root = {};
    });
    packages = [ pkgs.onedrive ];
    services = {
      "systemd-nspawn@".serviceConfig.DeviceAllow = [
        "char-drm rwm"
        "/dev/dri rw"
      ];
      aria2b = {
        after = [ "aria2.service" ];
        script = ''
          cd /var/lib/aria2
          ${pkgs.yes.nodePackages.aria2b}/bin/aria2b
        '';
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "multi-user.target" ];
      };
      cpupower-gui.enable = false;
    };
    user.services = {
      cpupower-gui.enable = false;
      nix-index = {
        environment = config.networking.proxy.envVars;
        script = ''
          FILE=index-x86_64-linux
          mkdir -p ~/.cache/nix-index
          cd ~/.cache/nix-index
          ${pkgs.curl}/bin/curl -LO https://github.com/Mic92/nix-index-database/releases/latest/download/$FILE
          mv -v $FILE files
        '';
        serviceConfig = {
          Restart = "on-failure";
          Type = "oneshot";
        };
        startAt = "weekly";
      };
      onedrive.wantedBy = [ "default.target" ];
      ss-ws-local = {
        script = ''
          if [ ! -f ~/.config/shadowsocks-ws/config.json ]; then
            echo "~/.config/shadowsocks-ws/config.json not found. Not starting."
            exit 0
          fi
          cd ~/.config/shadowsocks-ws
          ${pkgs.yes.nodePackages.shadowsocks-ws}/bin/ss-ws-local
        '';
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 15;
        };
        unitConfig = {
          StartLimitBurst = 5;
          StartLimitIntervalSec = 120;
        };
        wantedBy = [ "default.target" ];
      };
    };
  };
}