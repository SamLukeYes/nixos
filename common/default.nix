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
      ./services
      ./systemd.nix
      ./virtualisation
    ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  xdg.portal.xdgOpenUsePortal = true;

  zramSwap.enable = true;
}

