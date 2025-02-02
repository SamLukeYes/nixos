{ config, lib, ... }:

{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback      
    ];
    initrd.systemd.enable = true;
    kernelParams = lib.optional (!config.zramSwap.enable) "zswap.enabled=1";
    kernel.sysctl = {
      "dev.i915.perf_stream_paranoid" = 0;
    };
    loader = {
      systemd-boot = {
        editor = false;
        enable = lib.mkDefault true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    swraid.enable = lib.mkDefault false;
    tmp.cleanOnBoot = true;
  };
}