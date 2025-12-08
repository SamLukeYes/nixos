{ ... }:

{
  imports = [
    ./fileSystems.nix
    ./hardware-configuration.nix
    ../../common
    ../../optional/apps
    ../../optional/containers
    ../../optional/desktop/gnome.nix
    ../../optional/fonts
    ../../users/yes
  ];

  hardware.bluetooth.powerOnBoot = false;
  
  services = {
    thinkfan = {
      enable = true;
      smartSupport = true;
      levels = [
        ["level auto" 0 60]
        [7 59 32767]
      ];
    };

    tlp.settings = {
      START_CHARGE_THRESH_BAT0 = 50;
      STOP_CHARGE_THRESH_BAT0 = 60;
    };
  };

  system.stateVersion = "25.11";

  # TODO: add paru modules to archix
  programs.pacman.conf.extraConfig = ''
    [SamLukeYes]
    SigLevel = Never
    Server = file:///old-root/home/yes/paru-repo
  '';
}