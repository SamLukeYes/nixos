{ config, lib, ... }:

{
  boot = {
    kernelParams =
      lib.optional (!config.zramSwap.enable) "zswap.enabled=1"
      ++ lib.optionals config.virtualisation.virtualbox.host.enable
        (if config.virtualisation.virtualbox.host.enableKvm
        then [
          # https://github.com/cyberus-technology/virtualbox-kvm#known-issues-and-limitations
          "split_lock_detect=off"
        ]
        else [
          # https://github.com/NixOS/nixpkgs/issues/363887
          "kvm.enable_virt_at_load=0"
        ]);
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
  };
}