{ pkgs, ... }:

# This file is unmaintained. Only keep it in case I need it one day.

{
  imports = [
    ../dm/sddm.nix
  ];

  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/plasma6.nix
    # plasma6.excludePackages = with pkgs.kdePackages; [
    #   elisa                 # use haruna instead
    # ];

    variables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs; with kdePackages; [
      discover
      filelight
      # haruna
      krita
      kwalletmanager
      ksystemlog
      partition-manager

      # Maliit
      maliit-framework
      maliit-keyboard

      # CLI programs required by Plasma
      linuxquota
      pciutils
    ];
  };

  programs.ssh.startAgent = true;

  # security.pam.services.sddm.enableGnomeKeyring = true;

  services = {
    desktopManager.plasma6.enable = true;
  };
}