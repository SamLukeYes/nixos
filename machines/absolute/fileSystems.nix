{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "xfs";
    };
    "/home".device = "/dev/disk/by-label/data";

    # devtools optimizations
    "/var/lib/archbuild" = {
      fsType = "tmpfs";
      options = [ "size=15G" ];
    };
    "/var/lib/aurbuild" = {
      fsType = "tmpfs";
      options = [ "size=15G" ];
    };
  };
}