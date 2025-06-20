{ config, lib, ... }:

{
  imports = [
    ./systemPackages.nix
    ./trash.nix
  ];

  environment = {
    variables = {
      BROWSER = lib.getExe config.programs.firefox.package;
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_DBUS_REMOTE = "1";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      TZ = "/etc/localtime";
    };
  };
}
