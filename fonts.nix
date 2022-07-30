{config, pkgs, ...}:

{
  fonts = {
    fonts = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      inconsolata-nerdfont
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif CJK SC"];
      sansSerif = ["Noto Sans CJK SC"];
    };
  };
}