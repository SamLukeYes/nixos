{ pkgs, lib, ... }:

{
  imports = [
    ./pipewire.nix
  ];

  services = {
    aria2 = {
      downloadDir = "/home/aria2";
      enable = true;
      extraArguments = "--bt-tracker=${builtins.readFile "${pkgs.trackers}/all_aria2.txt"}";
    };

    cpupower-gui.enable = lib.mkDefault true;

    dbus.implementation = "broker";

    flatpak.enable = true;

    fstrim.enable = true;

    fwupd.enable = true;

    gnome.gnome-keyring.enable = true;

    logind.lidSwitch = "ignore";

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
