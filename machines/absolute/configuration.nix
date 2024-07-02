{ pkgs, ... }:

{
  imports = [
    ./fileSystems.nix
    ./hardware-configuration.nix
    ../../common
    ../../optional/apps
    ../../optional/fonts
    ../../optional/databases
    ../../users/yes
  ];

  hardware.bluetooth.powerOnBoot = false;
  
  services.thinkfan = {
    enable = true;
    smartSupport = true;
    levels = [
      ["level auto" 0 60]
      [7 59 32767]
    ];
  };

  system.stateVersion = "22.11";

  # systemd-nspawn
  systemd = {
    nspawn = (builtins.mapAttrs (name: value: {
      filesConfig = {
        Bind = [
          "/dev/dri"
          # "/dev/shm"
          # "/dev/snd"
          "/dev/video0"
        ];
        BindReadOnly = [
          "/etc/resolv.conf"
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

    services."systemd-nspawn@" = {
      serviceConfig.DeviceAllow = [
        "char-drm rwm"
        "char-usb_device rwm"
        "/dev/dri rw"
        # "/dev/shm rw"
        # "/dev/snd rw"
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
          ExecStart = "${pkgs.xorg.xhost}/bin/xhost +local:";
          ExecStop = "${pkgs.xorg.xhost}/bin/xhost -local:";
          RemainAfterExit = true;
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "default.target" ];
      };
    };
  };

  # TODO: add paru modules to archix
  programs.pacman.conf.extraConfig = ''
    [SamLukeYes]
    SigLevel = Never
    Server = file:///home/yes/paru-repo
  '';
}