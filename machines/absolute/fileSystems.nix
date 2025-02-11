{ ... }:

{
  fileSystems = {
    "/boot".device = "/dev/disk/by-label/SYSTEM";
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

  boot.tmp.cleanOnBoot = true;
  environment.persistence."/persistent".directories = [
    "/tmp"
    "/var/lib/bluetooth"
  ];
}