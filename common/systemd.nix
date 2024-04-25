{ config, pkgs, ... }:

let
  waitOnline = "${pkgs.networkmanager}/bin/nm-online";
in

{
  # TODO: clean up nspawn config
  systemd = {
    nspawn = (builtins.mapAttrs (name: value: {
      filesConfig = {
        Bind = [
          "/dev/dri"
          # "/dev/shm"
          "/dev/snd"
        ];
        BindReadOnly = [
          # "/run/user/1000/bus"
          "/tmp/.X11-unix"
        ];
      };
      networkConfig.Private = false;
    }) {
      archlinux = {};
      archriscv = {};
    });
    targets.machines.wants = [ "systemd-nspawn@archlinux.service" ];
    services = {
      "systemd-nspawn@" = {
        serviceConfig.DeviceAllow = [
          "char-drm rwm"
          "/dev/dri rw"
          # "/dev/shm rw"
          "/dev/snd rw"
        ];
      };
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
      pulse-server = {
        after = [ "pipewire-pulse.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.pulseaudio}/bin/pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
          Type = "oneshot";
        };
        wantedBy = [ "default.target" ];
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
          Restart = "always";
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
      xhost = {
        path = [ pkgs.xorg.xhost ];
        serviceConfig = {
          ExecStart = "xhost +local:";
          ExecStop = "xhost -local:";
          RemainAfterExit = true;
        };
        wantedBy = [ "default.target" ];
      };
    };

    tmpfiles.rules = [
      "z /sys/kernel/notes 0400 root root"
    ];
  };
}