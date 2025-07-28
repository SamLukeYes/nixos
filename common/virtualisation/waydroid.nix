{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.waydroid-helper ];

  virtualisation.waydroid.enable = true;

  services.dbus.packages = [ pkgs.waydroid-helper ];

  systemd.packages = [ pkgs.waydroid-helper ];

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/waydroid"
  ];

  users.persistence.directories = [
    ".local/share/waydroid"
  ];
}