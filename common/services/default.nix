{ pkgs, lib, ... }:

{
  imports = [
    ./flatpak.nix
    ./pipewire.nix
    ./v2raya.nix
  ];

  services = {
    cpupower-gui.enable = lib.mkDefault true;

    dbus.implementation = "broker";

    fstrim.enable = true;

    fwupd.enable = true;

    # gnome.gnome-keyring.enable = true;

    logind.lidSwitch = "ignore";

    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };

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
    };
  };
}
