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
    levels = [
      ["level auto" 0 60]
      [7 59 32767]
    ];
  };

  system.stateVersion = "22.11";

  # TODO: add paru modules to archix
  programs.pacman.conf.extraConfig = ''
    [SamLukeYes]
    SigLevel = Never
    Server = file:///home/yes/paru-repo
  '';
}