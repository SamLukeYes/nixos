{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-sans
      powerline-fonts
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "DejaVu Sans"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}