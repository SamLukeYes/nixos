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
    repoOverrides = {
      yes = import ./packages { inherit pkgs rp; };
    };
  };

in

{
  imports =
    [
      ./boot.nix
      ./environment.nix
      ./fonts.nix
      ./i18n.nix
      ./nix.nix
      ./programs.nix
      ./services.nix
      ./system.nix
      ./systemd.nix

      # The following files are not tracked by git
      ./hardware-configuration.nix
      ./users.nix

      "${builtins.fetchGit "${rp}https://github.com/NixOS/nixos-hardware"}/lenovo/thinkpad/l13/yoga"
    ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {

      inherit nur;

      adw-gtk3 = pkgs.callPackage (builtins.fetchurl 
        "https://cdn.jsdelivr.net/gh/InternetUnexplorer/nixpkgs-overlay/adw-gtk3/default.nix"
      ) {};

      electron-netease-cloud-music = nur.repos.rewine.electron-netease-cloud-music.overrideAttrs
        (old: rec {
          version = "0.9.35";
          src = pkgs.fetchurl {
            url = "${rp}https://github.com/Rocket1184/${old.pname}/releases/download/v${version}/${old.pname}_v${version}.asar";
            sha256 = "sha256-OD4xSytwJyFM0IrdN7elj6v5OFDO8viyGYls/Z3d+Hc=";
          };
        });
      
    };
  };

  zramSwap.enable = true;
}

