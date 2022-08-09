{ config, pkgs, ... }:

{
  boot = {
    # consoleLogLevel = 0;
    loader = {
      systemd-boot = {
        # configurationLimit = 10;
        editor = false;
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
    kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
    kernelParams = ["bgrt_disable"];
  };
}