{ pkgs, ...}:

{
  i18n = {
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [
        libpinyin
      ];
    };
    defaultLocale = "zh_CN.UTF-8";
    # supportedLocales = [
    #   "en_US.UTF-8/UTF-8"
    #   "zh_CN.UTF-8/UTF-8"
    # ];
  };
}