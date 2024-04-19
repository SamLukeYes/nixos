{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ./common
  ];

  boot = {
    initrd.systemd.enable = lib.mkForce false;
    plymouth.enable = lib.mkForce false;
  };

  environment.systemPackages = with pkgs; [
    arch-install-scripts
  ];

  isoImage.squashfsCompression = "zstd";

  networking.proxy.default = lib.mkForce null;

  programs.firefox.package = lib.mkForce pkgs.firefox;

  security.sudo-rs.enable = lib.mkForce false;

  users.defaultUserShell = config.programs.xonsh.package;
}