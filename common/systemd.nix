{ ... }:

# let
#   waitOnline = "${pkgs.networkmanager}/bin/nm-online";
# in

{
  systemd = {
    services.cpupower-gui.enable = false;
    user.services.cpupower-gui.enable = false;

    tmpfiles.rules = [
      "z /sys/kernel/notes 0400 root root"
    ];
  };
}