{config, pkgs, ...}:

{
  fonts = {
    fonts = with pkgs; [
      inconsolata-nerdfont
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      ubuntu_font_family
      win10-fonts
    ];
    fontconfig.defaultFonts = {
      serif = [
        "DejaVu Serif"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "Ubuntu"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}