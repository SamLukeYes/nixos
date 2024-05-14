{ lib, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Noto" ]; })
      rewine.ttf-ms-win10
    ];

    fontconfig.defaultFonts.monospace = lib.mkBefore [
      "NotoMono Nerd Font Mono"
    ];
  };
}