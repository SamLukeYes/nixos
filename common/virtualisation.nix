{ pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
    waydroid.enable = true;
  };
}