# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let rp = import ./reverse-proxy.nix; in

{
  imports =
    [
      ./boot.nix
      ./environment.nix
      ./fonts.nix
      ./i18n.nix
      ./nix.nix
      ./nixpkgs.nix
      ./programs.nix
      ./services.nix
      ./system.nix

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

  hardware.bluetooth.powerOnBoot = false;

  zramSwap.enable = true;
}

