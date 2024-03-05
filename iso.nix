{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ./common
  ];

  environment.systemPackages = with pkgs; [
    arch-install-scripts
  ];

  isoImage.squashfsCompression = "zstd";

  networking.proxy.default = lib.mkForce null;

  users.defaultUserShell = config.programs.xonsh.package;
}