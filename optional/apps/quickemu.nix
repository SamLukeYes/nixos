{ lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.quickemu ];

  boot.kernelParams = [ "kvm.ignore_msrs=1" ];
  
  security.wrappers.spice-client-glib-usb-acl-helper = {
    group = lib.mkForce "wheel";
    permissions = "u+rx,g+x";
  };

  virtualisation.spiceUSBRedirection.enable = true;
}