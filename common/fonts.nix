{ pkgs, ... }:

{
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Noto" ]; })
      noto-fonts-cjk-sans
      powerline-fonts
      rewine.ttf-ms-win10
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Microsoft YaHei UI"
      ];
      monospace = [
        "NotoMono Nerd Font Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}