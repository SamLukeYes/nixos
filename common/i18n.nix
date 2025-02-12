{ pkgs, ... }:

{
  i18n = {
    # defaultLocale = "zh_CN.UTF-8";
    inputMethod = {
      enable = true;
      type = "ibus";
      ibus = {
        engines = with pkgs.ibus-engines; [
          libpinyin
        ];
      };
    };
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];
  };

  users.persistence.directories = [
    ".cache/ibus/libpinyin"
  ];
}