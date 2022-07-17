# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./boot.nix
      ./environment.nix
      ./i18n.nix
      ./nix.nix
      ./programs.nix
      ./services.nix
      ./system.nix

      # The following files are not tracked by git
      ./hardware-configuration.nix
      ./users.nix
    ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # https://nixos.wiki/wiki/Fonts
  fonts.fonts = with pkgs; [
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  powerManagement.powertop.enable = true;

  systemd.services.set-energy-preference = {
    wantedBy = ["multi-user.target"];
    description = "Set energy preference to balance power";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/cpupower-gui ene --pref balance_power";
    };
  };

  # https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  
  # https://nixos.wiki/wiki/Accelerated_Video_Playback
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };

  hardware.sensor.iio.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      nur = import (builtins.fetchTarball 
        "https://github.com/nix-community/NUR/archive/master.tar.gz"
      ) {
        inherit pkgs;
      };
    };
  };

  # qt5.platformTheme = "gnome";

  zramSwap.enable = true;
}

