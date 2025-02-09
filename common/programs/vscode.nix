{ config, pkgs, ... }:

{
  environment.systemPackages = [
    ((pkgs.vscode.override {
        commandLineArgs = "--touch-events=true";
      }).fhsWithPackages (ps: with ps; [
        libGL                             # required by conda env
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