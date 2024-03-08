{ lib, pkgs, ... }:

{
  boot = {
    # binfmt.emulatedSystems = [ "riscv64-linux" ];
    # consoleLogLevel = 0;
    # extraModulePackages = with config.boot.kernelPackages; [
    #   v4l2loopback
    # ];
    initrd.systemd.enable = true;
    kernel.sysctl = {
      "dev.i915.perf_stream_paranoid" = 0;
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
    };
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [ "quiet" "udev.log_level=3" ];
    loader = {
      systemd-boot = {
        editor = false;
        enable = lib.mkDefault true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    plymouth.enable = true;
    swraid.enable = lib.mkDefault false;
    tmp.cleanOnBoot = true;
  };
}