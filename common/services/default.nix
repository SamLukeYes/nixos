{ pkgs, ... }:

{
  imports = [
    ./angrr.nix
    ./earlyoom.nix
    ./fwupd.nix
    ./syncthing.nix
  ];

  services = {
    avahi.enable = false;

    dbus.implementation = "broker";

    fstrim.enable = true;

    kmscon.enable = true;

    logind.settings.Login.HandleLidSwitch = "ignore";

    ollama.enable = true;

    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
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
