{ config, pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      ((vscode.override {
          commandLineArgs = "--touch-events=true --wayland-text-input-version=3";
        }).fhsWithPackages (ps: with ps; [
          libGL  # required by conda env
          pacman  # set up pacman.conf

          # for debugging upstream Shimeji-Desktop
          libX11
          libXrender
        ]
        # https://github.com/NixOS/nixpkgs/issues/356340
        ++ lib.optional
          config.services.desktopManager.gnome.enable gnome-shell
      ))

      nil  # for VSCode nix IDE
      python3Packages.python-lsp-server  # for VSCode xonsh IDE
      wl-clipboard-x11  # for VSCode Office Viewer Markdown Editor
    ];

    gnome.excludePackages = with pkgs; [
      gnome-text-editor
    ];
  };

  users.persistence.directories = [
    ".config/Code"
  ];
}