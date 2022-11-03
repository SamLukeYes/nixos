{
  imports = [
    ./hardware-configuration.nix
    ../../common
  ];
  
  hardware.bluetooth.powerOnBoot = false;

  networking.hostName = "absolute";
}