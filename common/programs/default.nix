{ ... }:

{
  imports = [
    ./android.nix
    ./audacity.nix
    ./authenticator.nix
    ./czkawka.nix
    ./dconf.nix
    ./direnv.nix
    ./fastfetch.nix
    ./firefox.nix
    ./foliate.nix
    ./gimp.nix
    ./git.nix
    ./gnupg.nix
    ./libreoffice.nix
    ./nodejs.nix
    ./pacman.nix
    ./pixi.nix
    ./shijima.nix
    ./telegram.nix
    ./vscode.nix
    ./xonsh.nix
    ./xournalpp.nix
  ];

  programs = {
    bat.enable = true;

    command-not-found.enable = false;

    # requires nix-index-database
    nix-index-database.comma.enable = true;

    starship = {
      enable = true;
      settings = {
        battery.display = [
          {
            style = "bold red";
            threshold = 40;
          }
          {
            style = "bold yellow";
            threshold = 50;
          }
          {
            style = "bold green";
            threshold = 100;
          }
        ];
        line_break.disabled = true;
        package.disabled = true;
        shell.disabled = false;
        shlvl.disabled = false;
        status.disabled = false;
        time = {
          disabled = false;
          format = "🕙$time($style) ";
        };
      };
    };
  };
}
