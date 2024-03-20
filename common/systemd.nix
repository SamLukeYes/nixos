{ config, pkgs, ... }:

let
  waitOnline = "${pkgs.networkmanager}/bin/nm-online";
in

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
    # oomd = {
    #   # enableRootSlice = true;
    #   enableUserSlices = true;
    # };
    services = {
      "systemd-nspawn@".serviceConfig.DeviceAllow = [
        "char-drm rwm"
        "/dev/dri rw"
      ];
      cpupower-gui.enable = false;
    };
    user.services = {
      cpupower-gui.enable = false;
      nix-index = {
        environment = config.networking.proxy.envVars;
        script = ''
          ${waitOnline}
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
      sslocal = let
        configFile = "%h/.config/shadowsocks/config.json";
      in {
        serviceConfig = {
          ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c ${configFile}";
          Restart = "on-failure";
        };
        unitConfig.ConditionFileNotEmpty = configFile;
        wantedBy = [ "default.target" ];
      };
      ss-ws-local = let
        configDir = "%h/.config/shadowsocks-ws";
      in {
        serviceConfig = {
          ExecStartPre = waitOnline;
          ExecStart = "${pkgs.yes.nodePackages.shadowsocks-ws}/bin/ss-ws-local";
          Restart = "on-failure";
          RestartSec = 5;
          WorkingDirectory = configDir;
        };
        unitConfig = {
          ConditionFileNotEmpty = "${configDir}/config.json";
          StartLimitBurst = 5;
          StartLimitIntervalSec = 60;
        };
        wantedBy = [ "default.target" ];
      };
    };
  };
}