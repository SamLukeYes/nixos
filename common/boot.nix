{ config, lib, ... }:

{
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback      
    ];
    initrd.systemd.enable = true;
    kernelParams =
      lib.optional (!config.zramSwap.enable) "zswap.enabled=1"
      # https://github.com/NixOS/nixpkgs/issues/363887
      ++ lib.optional (with config.virtualisation.virtualbox.host; enable && !enableKvm) "kvm.enable_virt_at_load=0";
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