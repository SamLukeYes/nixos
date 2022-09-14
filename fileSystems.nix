{
  fileSystems = {
    "/".device = "/dev/disk/by-label/root";
    "/home".device = "/dev/disk/by-label/data";
    "/var/lib/archbuild" = {
      device = "/var/archbuild.img";
      options = [ "compress=zstd" "autodefrag" ];
    };
    "/var/lib/aurbuild" = {
      fsType = "tmpfs";
      options = [ "size=15G" ];
    };
  };
}