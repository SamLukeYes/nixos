{ lib, ... }:

{
  imports =
    [
      ./boot.nix
      ./environment
      ./fonts.nix
      ./i18n.nix
      ./nix.nix
      ./preservation.nix
      ./programs
      ./security.nix
      ./services
      ./systemd.nix
      ./virtualisation
    ];

  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  time.timeZone = "Asia/Shanghai";

  users.defaultUserShell = "/run/current-system/sw/bin/xonsh";

  xdg.portal.xdgOpenUsePortal = true;
}

