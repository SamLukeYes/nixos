{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../users/yes
  ];

  hardware.bluetooth.powerOnBoot = false;
  system.stateVersion = "22.11";

  # TODO: add paru modules to archix
  programs.pacman.conf.extraConfig = ''
    [SamLukeYes]
    SigLevel = Never
    Server = file:///home/yes/paru-repo
  '';
}