{ ... }:

{
  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/SYSTEM";
      options = [
        # https://github.com/nix-community/disko/issues/527
        "umask=0077"
      ];
    };
    "/persistent" = {
      device = "/dev/disk/by-label/root";
      fsType = "xfs";
      neededForBoot = true;
    };
    "/persistent/home" = {
      device = "/dev/disk/by-label/data";
      neededForBoot = true;
    };
  };

  swapDevices = [{
    device = "/persistent/var/swapfile";
    size = 16 * 1024;
  }];

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/bluetooth"
  ];
}