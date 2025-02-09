{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (if config.services.desktopManager.plasma6.enable
    then libreoffice-qt6
    else libreoffice)
  ];

  users.persistence.directories = [
    ".config/libreoffice"
  ];
}