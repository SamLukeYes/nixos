{
  imports = [
    ./hardware-configuration.nix
    ../../common
  ];
  
  hardware.bluetooth.powerOnBoot = false;
}