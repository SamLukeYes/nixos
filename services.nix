{ config, pkgs, lib, ... }:

{
  services = {

    aria2 = {
      enable = true;
      downloadDir = "/home/aria2";
    };

    cpupower-gui.enable = true;

    fstrim.enable = true;

    fwupd.enable = true;

    # Disable the event list of the calendar menu
    gnome.evolution-data-server.enable = lib.mkForce false;

    onedrive.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };

    power-profiles-daemon.enable = false;

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
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.desktop.peripherals.touchpad]
          tap-to-click=true
        '';
        extraGSettingsOverridePackages = with pkgs; [
          gsettings-desktop-schemas
        ];
      };
      displayManager.gdm.enable = true;
    };

  };
}
