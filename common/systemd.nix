{ config, pkgs, ... }:

{
  # TODO: clean up nspawn config
  systemd = {
    nspawn = (builtins.mapAttrs (name: value: {
      filesConfig.Bind = [ "/dev/dri" ];
      networkConfig.Private = false;
    }) {
      archriscv = {};
      old-root = {};
    });
    oomd = {
      # enableRootSlice = true;
      enableUserSlices = true;
    };
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
      sslocal = {
        serviceConfig = {
          ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c %h/.config/shadowsocks/config.json";
          Restart = "on-failure";
        };
        unitConfig.ConditionFileNotEmpty = "%h/.config/shadowsocks-ws/config.json";
        wantedBy = [ "default.target" ];
      };
      ss-ws-local = {
        serviceConfig = {
          ExecStart = "${pkgs.yes.nodePackages.shadowsocks-ws}/bin/ss-ws-local";
          Restart = "on-failure";
          RestartSec = 5;
          WorkingDirectory = "%h/.config/shadowsocks-ws";
        };
        unitConfig = {
          ConditionFileNotEmpty = "%h/.config/shadowsocks-ws/config.json";
          StartLimitBurst = 5;
          StartLimitIntervalSec = 60;
        };
        wantedBy = [ "default.target" ];
      };
    };
  };
}