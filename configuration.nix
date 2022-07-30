# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let

  rp = (import ./reverse-proxy.nix);

  nur = import (builtins.fetchTarball 
    "${rp}https://github.com/nix-community/NUR/archive/master.tar.gz"
  ) {
    inherit pkgs;
  };

in

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
      ./systemd.nix

      # The following files are not tracked by git
      ./hardware-configuration.nix
      ./users.nix
    ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # https://nixos.wiki/wiki/Fonts
  fonts.fonts = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    inconsolata-nerdfont
  ];

  powerManagement.powertop.enable = true;

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

      inherit nur;

      adw-gtk3 = pkgs.callPackage (builtins.fetchurl 
        "https://cdn.jsdelivr.net/gh/InternetUnexplorer/nixpkgs-overlay/adw-gtk3/default.nix"
      ) {};
      
      custom = import ./packages { inherit rp; };
      
    };
  };

  # qt5.platformTheme = "gnome";

  zramSwap.enable = true;
}

