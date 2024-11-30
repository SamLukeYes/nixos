{ lib, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.noto
      rewine.ttf-ms-win10
    ];

    fontconfig.defaultFonts.monospace = lib.mkBefore [
      "NotoMono Nerd Font Mono"
    ];
  };
}