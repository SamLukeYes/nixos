{ config, pkgs, ... }:

{
  imports = [
    ./tomcat.nix
  ];

  environment.systemPackages = with pkgs; [
    charles
    yes.ludii

    # CLI tools
    pdftk                         # required by Jasminum
  ] ++ (if config.services.xserver.desktopManager.gnome.enable
    then [ shimeji.fhs4gnome ]
    else [ shimeji.default ]);

  programs.java.enable = true;
}