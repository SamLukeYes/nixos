{
  imports =
    [
      ./boot.nix
      ./environment
      ./fonts.nix
      ./i18n.nix
      ./networking.nix
      ./nix.nix
      ./programs.nix
      ./security.nix
      ./services
      ./systemd.nix
      ./virtualisation.nix
    ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  xdg.portal.xdgOpenUsePortal = true;

  zramSwap.enable = true;
}

