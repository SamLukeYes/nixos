{ config, pkgs, ... }:

{
  imports = [
    ./charles.nix
  ];

  environment.systemPackages = with pkgs; [
  ] ++ (if config.services.xserver.desktopManager.gnome.enable
    then [ shimeji.fhs4gnome ]
    else [ shimeji.default ]);

  programs.java.enable = true;
}