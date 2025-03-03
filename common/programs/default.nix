{ ... }:

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

    # requires nix-index-database
    nix-index-database.comma.enable = true;
  };
}
