{ ... }:

# let
#   waitOnline = "${pkgs.networkmanager}/bin/nm-online";
# in

{
  systemd = {
    tmpfiles.rules = [
      "z /sys/kernel/notes 0400 root root"
    ];
  };

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/systemd/backlight"
  ];
}