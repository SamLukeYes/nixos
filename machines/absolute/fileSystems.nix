{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "xfs";
    };
    "/home".device = "/dev/disk/by-label/data";

    # devtools optimizations
    "/var/lib/archbuild" = {
      device = "/home/archbuild.img";
      options = [ "compress=zstd" "autodefrag" ];
    };
    "/var/lib/aurbuild" = {
      fsType = "tmpfs";
      options = [ "size=15G" ];
    };
  };
}