{ ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/root";
      fsType = "xfs";
    };
    "/persistent/home" = {
      device = "/dev/disk/by-label/data";
      neededForBoot = true;
    };

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