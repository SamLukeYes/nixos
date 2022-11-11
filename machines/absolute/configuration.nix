{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../users/yes
  ];
  
  hardware.bluetooth.powerOnBoot = false;
  networking.hostName = "absolute";
  system.stateVersion = "22.11";
}