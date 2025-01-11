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
      ./virtualisation.nix
    ];

  system.rebuild.enableNg = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  xdg.portal.xdgOpenUsePortal = true;
}

