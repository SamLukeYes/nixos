final: prev:

with prev;

let rp = import ./reverse-proxy.nix; in rec {
  nur = import (builtins.fetchTarball 
    "${rp}https://github.com/nix-community/NUR/archive/master.tar.gz"
  ) rec {
    pkgs = prev;
    repoOverrides = {
      # xddxdd = import ./xddxdd-nur-packages { inherit pkgs; };
      yes = import ./packages { inherit pkgs rp; };
    };
  };

  # https://github.com/NixOS/nixpkgs/pull/189678
  # arch-install-scripts = callPackage "${
  #   builtins.fetchTarball "${rp}https://github.com/SamLukeYes/nixpkgs/archive/arch-install-scripts.tar.gz"
  # }/pkgs/tools/misc/arch-install-scripts" {};

  electron-netease-cloud-music = callPackage (builtins.fetchurl 
    "https://cdn.jsdelivr.net/gh/wineee/nur-packages/packages/electron-netease-cloud-music/default.nix"
  ) {};

  firefox = firefox-esr-wayland;

  my-python = python3.withPackages (p: with p; [
    ipykernel openpyxl statsmodels
  ]);

  # https://github.com/NixOS/nixpkgs/pull/192896
  pacman = callPackage "${
    builtins.fetchTarball "${rp}https://github.com/SamLukeYes/nixpkgs/archive/pacman.tar.gz"
  }/pkgs/tools/package-management/pacman" {};

  # https://github.com/NixOS/nixpkgs/pull/189091
  pano = callPackage "${
    builtins.fetchTarball "${rp}https://github.com/michojel/nixpkgs/archive/gnome-shell-extension-pano.tar.gz"
  }/pkgs/desktops/gnome/extensions/pano" {};

  wemeet = let _wemeet = nur.repos.linyinfeng.wemeet; in stdenvNoCC.mkDerivation {
    inherit (_wemeet) version;
    pname = "wemeet-x11";
    buildCommand = ''
      mkdir -p $out/
      cp -r ${_wemeet}/share $out/
      substituteInPlace $out/share/applications/wemeetapp.desktop \
        --replace "Exec=wemeetapp" "Exec=${_wemeet}/bin/wemeetapp-force-x11"
    '';
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