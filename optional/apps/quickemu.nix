{ lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.quickemu ];
  
  security.wrappers.spice-client-glib-usb-acl-helper = {
    group = lib.mkForce "wheel";
    permissions = "u+rx,g+x";
  };

  virtualisation.spiceUSBRedirection.enable = true;
}