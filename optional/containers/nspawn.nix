{ pkgs, ... }:

{
  systemd = {
    nspawn = (builtins.mapAttrs (name: value: {
      filesConfig = {
        Bind = [
          "/dev/dri"
          "/dev/video0"
        ];
        BindReadOnly = [
          "/etc/resolv.conf"
          "/tmp/.X11-unix"
        ];
      };
      networkConfig.Private = false;
    }) {
      archlinux = {};
    });

    targets.machines.wants = [ "systemd-nspawn@archlinux.service" ];

    services."systemd-nspawn@" = {
      serviceConfig.DeviceAllow = [
        "char-drm rwm"
        "char-usb_device rwm"
        "/dev/dri rw"
        "/dev/video0 rwm"
      ];
    };

    user.services = {
      pulse-server = {
        after = [ "pipewire-pulse.service" ];
        serviceConfig = {
          ExecStart = "${pkgs.pulseaudio}/bin/pactl load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
          ExecStop = "${pkgs.pulseaudio}/bin/pactl unload-module module-native-protocol-tcp";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "default.target" ];
      };

      xhost = {
        serviceConfig = {
          ExecStart = "${pkgs.xhost}/bin/xhost +local:";
          ExecStop = "${pkgs.xhost}/bin/xhost -local:";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "default.target" ];
      };
    };
  };

  preservation.preserveAt."/persistent".directories = [
    "/old-root"
    "/var/lib/machines"
  ];
}