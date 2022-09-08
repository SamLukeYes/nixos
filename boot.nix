{ config, pkgs, ... }:

{
  boot = {
    # consoleLogLevel = 0;
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    kernel.sysctl = {
      "dev.i915.perf_stream_paranoid" = 0;
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
    kernelParams = ["bgrt_disable"];
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
  };
}