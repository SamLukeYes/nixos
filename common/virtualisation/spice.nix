{ lib, ... }:

{
  virtualisation.spiceUSBRedirection.enable = true;

  security.wrappers.spice-client-glib-usb-acl-helper = {
    group = lib.mkForce "wheel";
    permissions = "u+rx,g+x";
  };
}