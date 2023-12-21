{
  imports = [
    ./fileSystems.nix
    ./hardware-configuration.nix
    ../../common
    ../../optional/apps
    ../../users/yes
  ];

  hardware.bluetooth.powerOnBoot = false;
  
  services.thinkfan = {
    enable = true;
    smartSupport = true;
  };

  system.stateVersion = "22.11";

  # TODO: add paru modules to archix
  programs.pacman.conf.extraConfig = ''
    [SamLukeYes]
    SigLevel = Never
    Server = file:///home/yes/paru-repo
  '';
}