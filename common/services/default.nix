{ pkgs, lib, ... }:

{
  imports = [
    ./angrr.nix
    ./earlyoom.nix
  ];

  services = {
    avahi.enable = false;

    cpupower-gui.enable = lib.mkDefault true;

    dbus.implementation = "broker";

    fstrim.enable = true;

    fwupd.enable = true;

    logind.lidSwitch = "ignore";

    ollama.enable = true;

    power-profiles-daemon.enable = false;

    throttled.enable = false;

    tlp = {
      enable = true;
      settings = {
        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_power";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      };
    };

    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      windowManager.icewm.enable = true;
    };
  };
}
