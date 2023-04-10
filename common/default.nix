{ pkgs, ... }:

{
  imports =
    [
      ./boot.nix
      ./environment
      ./fileSystems.nix
      ./fonts.nix
      ./i18n.nix
      ./nix.nix
      ./programs.nix
      ./services
      ./systemd.nix
      ./virtualisation.nix
    ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  zramSwap.enable = true;
}

