{ ... }:

{
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeSwapThreshold = 50;
    freeSwapKillThreshold = 10;
  };

  systemd.oomd.enable = false;
}