{ config, lib, pkgs, ... }:

{
  imports = [
    ./audacity.nix
    ./authenticator.nix
    ./czkawka.nix
    ./dconf.nix
    ./direnv.nix
    ./fastfetch.nix
    ./firefox.nix
    ./gimp.nix
    ./git.nix
    ./gnupg.nix
    ./libreoffice.nix
    ./nodejs.nix
    ./pacman.nix
    ./pixi.nix
    ./telegram.nix
    ./vscode.nix
    ./xonsh.nix
    ./xournalpp.nix
  ];

  programs = {
    command-not-found.enable = false;

    kdeconnect = {
      enable = true;
      package = lib.mkIf
        config.services.xserver.desktopManager.gnome.enable
        pkgs.gnomeExtensions.gsconnect;
    };

    # requires nix-index-database
    nix-index-database.comma.enable = true;
  };
}
