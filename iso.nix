{ config, lib, modulesPath, pkgs, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ./common
    ./optional/desktop/gnome.nix
  ];

  boot.initrd.systemd.enable = lib.mkForce false;

  environment.systemPackages = with pkgs; [
    arch-install-scripts
  ];

  isoImage.squashfsCompression = "zstd";

  networking.proxy.default = lib.mkForce null;

  programs.firefox.package = lib.mkForce pkgs.firefox;

  systemd = {
    additionalUpstreamSystemUnits = [ "systemd-time-wait-sync.service" ];
    services.systemd-time-wait-sync.wantedBy = [ "multi-user.target" ];
  };

  users.defaultUserShell = config.programs.xonsh.package;
}