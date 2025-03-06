{ config, lib, pkgs, ... }:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    systemService = false;
  };

  systemd.user.services.syncthing.wantedBy = [ "graphical-session.target" ];

  environment.systemPackages = [
    pkgs.syncthing
  ] ++ lib.optional config.services.xserver.desktopManager.gnome.enable
    pkgs.gnomeExtensions.syncthing-indicator;

  users.persistence.directories = [
    ".config/syncthing"
  ];
}