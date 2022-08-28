final: prev:

with prev;

let rp = import ./reverse-proxy.nix; in

{
  nur = import (builtins.fetchTarball 
    "${rp}https://github.com/nix-community/NUR/archive/master.tar.gz"
  ) rec {
    pkgs = prev;
    repoOverrides = {
      yes = import ./packages { inherit pkgs rp; };
    };
  };

  electron-netease-cloud-music = (callPackage (builtins.fetchurl 
    "https://cdn.jsdelivr.net/gh/wineee/nur-packages/pkgs/electron-netease-cloud-music/default.nix"
  ) {}).overrideAttrs (old: rec {
    version = "0.9.36";
    src = fetchurl {
      url = "${rp}https://github.com/Rocket1184/${old.pname}/releases/download/v${version}/${old.pname}_v${version}.asar";
      sha256 = "sha256-ElJKdI+yuvvjUtqEulyFHz3VvMKXgAbX9QXwRk1oQkg=";
    };
  });

  firefox = firefox-esr-wayland;

  # https://github.com/NixOS/nixpkgs/pull/187764
  vscode = (callPackage "${
    builtins.fetchTarball "${rp}https://github.com/SamLukeYes/nixpkgs/archive/vscode.tar.gz"
  }/pkgs/applications/editors/vscode/vscode.nix" {}).override {
    commandLineArgs = "--touch-events -w";
  };

  win10-fonts = (callPackage (builtins.fetchurl 
    "https://cdn.jsdelivr.net/gh/VergeDX/nur-packages/pkgs/Win10_LTSC_2021_fonts/default.nix"
  ) {}).overrideAttrs (old: {
    src = fetchurl {
      url = "${rp}https://software-download.microsoft.com/download/pr/19043.928.210409-1212.21h1_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso";
      sha256 = "026607e7aa7ff80441045d8830556bf8899062ca9b3c543702f112dd6ffe6078";
    };
  });
}