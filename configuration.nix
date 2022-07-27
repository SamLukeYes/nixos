# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let rp = (import ./reverse-proxy.nix); in

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
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    (nur.repos.vanilla.Win10_LTSC_2021_fonts.overrideAttrs (oldAttrs: rec {
      src = fetchurl {
        url = "${rp}https://software-download.microsoft.com/download/pr/19043.928.210409-1212.21h1_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
        sha256 = "026607e7aa7ff80441045d8830556bf8899062ca9b3c543702f112dd6ffe6078";
      };
    }))
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

      nur = import (builtins.fetchTarball 
        "${rp}https://github.com/nix-community/NUR/archive/master.tar.gz"
      ) {
        inherit pkgs;
      };

      adw-gtk3 = pkgs.callPackage "${builtins.fetchTarball 
        "${rp}https://github.com/InternetUnexplorer/nixpkgs-overlay/archive/main.tar.gz"
      }/adw-gtk3" {};
      
      lx-music-desktop = pkgs.callPackage ./lx-music-desktop { inherit rp; };
      
    };
  };

  # qt5.platformTheme = "gnome";

  zramSwap.enable = true;
}

