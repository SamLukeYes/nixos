{config, pkgs, ...}:

let rp = (import ./reverse-proxy.nix); in

{
  fonts = {
    fonts = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      inconsolata-nerdfont
      (nur.repos.vanilla.Win10_LTSC_2021_fonts.overrideAttrs (oldAttrs: rec {
        src = fetchurl {
          url = "${rp}https://software-download.microsoft.com/download/pr/19043.928.210409-1212.21h1_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
          sha256 = "026607e7aa7ff80441045d8830556bf8899062ca9b3c543702f112dd6ffe6078";
        };
      }))
    ];
    fontconfig.defaultFonts = {
      serif = ["Noto Serif CJK SC"];
      sansSerif = ["Noto Sans CJK SC"];
      monospace = [
        "DejaVu Sans Mono"
        "Noto Sans Mono CJK SC"
      ];
    };
  };
}