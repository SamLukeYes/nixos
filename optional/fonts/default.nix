{ lib, pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.noto
    ];

    fontconfig.defaultFonts.monospace = lib.mkBefore [
      "NotoMono Nerd Font Mono"
    ];
  };
}