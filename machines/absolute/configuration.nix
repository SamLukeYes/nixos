{ pkgs, ... }:

{
  imports = [
    ./fileSystems.nix
    ./hardware-configuration.nix
    ../../common
    ../../optional/apps
    ../../optional/containers
    ../../optional/databases
    ../../optional/fonts
    ../../users/yes
  ];

  hardware.bluetooth.powerOnBoot = false;
  
  services = {
    thinkfan = {
      enable = true;
      smartSupport = true;
      levels = [
        ["level auto" 0 60]
        [7 59 32767]
      ];
    };

    tlp.settings = {
      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 60;
    };
  };

  swapDevices = [{
    device = "/var/swapfile";
    size = 16 * 1024;
  }];

  system.stateVersion = "22.11";

  # systemd-nspawn
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