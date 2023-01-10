{ config, pkgs, ... }:

{
  boot = {
    # consoleLogLevel = 0;
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    initrd.verbose = false;
    kernel.sysctl = {
      "dev.i915.perf_stream_paranoid" = 0;
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
    kernelPackages = pkgs.linuxPackages_testing_bcachefs;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    loader = {
      systemd-boot = {
        editor = false;
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";
      };
    };
    plymouth.enable = true;
  };
}