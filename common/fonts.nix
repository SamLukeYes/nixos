{config, pkgs, ...}:

{
  fonts = {
    fonts = with pkgs; [
      inconsolata-nerdfont
      noto-fonts-cjk-sans
      powerline-fonts
      rewine.ttf-ms-win10
    ];
    fontconfig.defaultFonts = {
      sansSerif = [
        "Microsoft YaHei UI"
      ];
      monospace = [
        "Noto Mono for Powerline"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}