{ config, pkgs, ... }:

{
  environment.systemPackages = [
    ((pkgs.vscode.override {
        commandLineArgs = "--touch-events=true --wayland-text-input-version=3";
      }).fhsWithPackages (ps: with ps; [
        libGL  # required by conda env

        # for debugging upstream Shimeji-Desktop
        xorg.libX11
        xorg.libXrender
      ]
      # https://github.com/NixOS/nixpkgs/issues/356340
      ++ lib.optional
        config.services.xserver.desktopManager.gnome.enable gnome-shell
    ))
  ];

  users.persistence.directories = [
    ".config/Code"
  ];
}