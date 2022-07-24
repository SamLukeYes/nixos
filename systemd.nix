{ config, pkgs, ... }:

{
  systemd = {
    nspawn.old-root.networkConfig.Private = false;
    services.set-energy-preference = {
      wantedBy = ["multi-user.target"];
      description = "Set energy preference to balance power";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "/run/current-system/sw/bin/cpupower-gui ene --pref balance_power";
      };
    };
  };
}