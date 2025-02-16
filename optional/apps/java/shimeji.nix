{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
  ] ++ (if config.services.xserver.desktopManager.gnome.enable
    then [ shimeji.fhs4gnome ]
    else [ shimeji.default ]);

  users.persistence.directories = [
    ".local/share/shimeji-desktop"
  ];
}