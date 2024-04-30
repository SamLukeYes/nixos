{ config, pkgs, lib, ... }:

{
  imports = [
    # ./earlyoom.nix
    ./pipewire.nix
    ./tomcat.nix
    ./v2raya.nix
  ];

  services = {
    cpupower-gui.enable = lib.mkDefault true;

    dbus.implementation = "broker";

    fstrim.enable = true;

    fwupd.enable = true;

    jenkins = {
      enable = true;
      packages = with config; [
        nix.package
        programs.git.package
        programs.java.package
        programs.ssh.package
      ];
      port = 8083;
    };

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
