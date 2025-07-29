{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.waydroid-helper ];

  virtualisation.waydroid.enable = true;

  services.dbus.packages = [ pkgs.waydroid-helper ];

  systemd = {
    packages = [ pkgs.waydroid-helper ];
    tmpfiles.rules = [
      "f+ /var/lib/waydroid/waydroid.log 0666 root root"
    ];
  };

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/waydroid"
  ];

  users.persistence.directories = [
    ".config/systemd/user/waydroid-monitor.service.d/"
    ".local/share/waydroid"
  ];
}