{config, pkgs, ...}:

{
  fonts = {
    fonts = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      inconsolata-nerdfont
      win10-fonts
    ];
    fontconfig.defaultFonts = {
      serif = [
        "DejaVu Serif"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "Source Sans 3"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}