{ config, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ./common
  ];

  isoImage.squashfsCompression = "zstd";

  networking.proxy.default = lib.mkForce null;

  users.defaultUserShell = config.programs.xonsh.package;
}