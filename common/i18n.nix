{ config, pkgs, ... }:

{
  i18n = {
    # defaultLocale = "zh_CN.UTF-8";
    inputMethod = if config.services.xserver.desktopManager.gnome.enable
      then {
        enabled = "ibus";
        ibus.engines = with pkgs.ibus-engines; [
          libpinyin
        ];
      }
      else {
        enabled = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [
            fcitx5-chinese-addons
          ];
          waylandFrontend = true;
        };
      };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };
}