{ config, lib, pkgs, ... }:

{
  imports = [ ./systemPackages.nix ];

  environment = {
    extraSetup = lib.optionalString (!config.services.printing.enable) ''
      rm $out/share/applications/cups.desktop
    '';

    homeBinInPath = true;

    variables = {
      BASH_COMPLETIONS = ["${pkgs.bash-completion}/share/bash-completion/bash_completion"];
      BROWSER = lib.getExe config.programs.firefox.package;
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_DBUS_REMOTE = "1";
      MOZ_ENABLE_WAYLAND = "1";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      TZ = "/etc/localtime";

      # use wayland ime
      GTK_IM_MODULE = lib.mkForce "";
      QT_IM_MODULE = lib.mkForce "";
    };
  };
}
