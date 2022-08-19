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
        "FreeSerif"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "FreeSans"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}