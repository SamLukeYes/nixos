{config, pkgs, ...}:

{
  fonts = {
    fonts = with pkgs; [
      inconsolata-nerdfont
      noto-fonts-cjk-sans
      powerline-fonts
      win10-fonts
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Microsoft YaHei UI"
      ];
      monospace = [
        "Noto Mono for Powerline"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}