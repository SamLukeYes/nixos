{ pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu.ovmf.packages = with pkgs; [
        OVMF.fd ovmf-loongarch
      ];
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
    waydroid.enable = true;
  };
}