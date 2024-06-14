{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      powerline-fonts
      source-han-serif
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Cantarell"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}