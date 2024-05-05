{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Noto" ]; })
      noto-fonts-cjk-sans
      powerline-fonts
      rewine.ttf-ms-win10
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Cantarell"
        "Noto Sans CJK SC"
      ];
      monospace = [
        "NotoMono Nerd Font Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}