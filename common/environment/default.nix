{ config, pkgs, ... }:

{
  imports = [ ./systemPackages.nix ];
  environment = {
    homeBinInPath = true;

    sessionVariables = {
      BASH_COMPLETIONS = ["${pkgs.bash-completion}/share/bash-completion/bash_completion"];
      BROWSER = "${config.programs.firefox.package}/bin/firefox";
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_DBUS_REMOTE = "1";
      MOZ_USE_XINPUT2 = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
      SDL_VIDEODRIVER = "wayland";
      TZ = "/etc/localtime";
    };
  };
}
