{ config, pkgs, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
    kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
  };
}