{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      powerline-fonts
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Cantarell"
        "Noto Sans CJK SC"
      ];
      serif = [
        "Noto Serif CJK SC"
      ];
      monospace = [
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}