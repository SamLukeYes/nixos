{ lib, ... }:

{
  imports =
    [
      ./boot.nix
      ./environment
      ./fonts.nix
      ./i18n.nix
      ./nix.nix
      ./programs.nix
      ./services
      ./systemd.nix
      ./virtualisation.nix
    ];

  networking.networkmanager.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  system.rebuild.enableNg = true;

  time.timeZone = "Asia/Shanghai";

  xdg.portal.xdgOpenUsePortal = true;
}

