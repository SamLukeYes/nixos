{config, pkgs, ...}:

{
  fonts = {
    fonts = with pkgs; [
      inconsolata-nerdfont
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      powerline-fonts
      win10-fonts
    ];
    fontconfig.defaultFonts = {
      serif = [
        "Noto Serif"
        "Noto Serif CJK SC"
      ];
      sansSerif = [
        "Noto Sans"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "Noto Sans Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}