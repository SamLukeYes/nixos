# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    archix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/archix";
    };
    archlinuxcn-keyring = {
      flake = false;
      url = "github:archlinuxcn/archlinuxcn-keyring";
    };
    cpupower-gui = {
      flake = false;
      url = "github:vagnum08/cpupower-gui";
    };
    flake-utils.follows = "archix/xddxdd/flake-utils";
    flake-utils-plus.follows = "archix/xddxdd/flake-utils-plus";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    rewine = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:wineee/nur-packages";
    };
    # starship = {
    #   flake = false;
    #   url = "github:starship/starship";
    # };
    trackers = {
      flake = false;
      url = "github:XIU2/TrackersListCollection";
    };
    yes = {
      flake = false;
      url = "github:SamLukeYes/nix-custom-packages";
    };

    # nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs: 
  let
    # rp = import ./rp.nix;
    system = "x86_64-linux";
    channel-patches = [
      # Add nixpkgs patches here
      ./patches/nixos-rebuild-use-nom.patch
    ];

  in flake-utils-plus.lib.mkFlake rec {
    inherit self inputs;
    channelsConfig.allowUnfree = true;
    sharedOverlays = [ self.overlays.default ];
    supportedSystems = [ system ];

    channels = {
      nixos-unstable = {
        input = nixpkgs;
        patches = channel-patches;
      };
    };

    hostDefaults = {
      inherit system;
      channelName = "nixos-unstable";
      modules = [
        inputs.archix.nixosModules.default
        inputs.archix.nixosModules.binfmt
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
        ./machines/absolute/configuration.nix
      ];
    };

    hosts = {
      absolute-gnome.modules = [
        ./optional/desktop/gnome.nix
      ];
      absolute-plasma.modules = [
        ./optional/desktop/plasma.nix
      ];
    };

    legacyPackages.${system} = import (
      flake-utils-plus.lib.patchChannel system nixpkgs channel-patches
    ) {
      inherit system;
      config = channelsConfig;
      overlays = sharedOverlays;
    };

    overlays.default = final: prev: {
      archix = inputs.archix.packages.${system};
      archlinuxcn-keyring = inputs.archlinuxcn-keyring;
      clash-verge = prev.clash-verge.overrideAttrs (old: rec {
        version = "1.3.7";
        src = final.fetchurl {
          url = "https://github.com/zzzgydi/clash-verge/releases/download/v${version}/clash-verge_${version}_amd64.deb";
          hash = "sha256-+RYfGLa4d5JkLWnlYfhjCOSREVJ4ad/R36eSiNj3GIA=";
        };
        postFixup = "ln -s ${final.clash}/bin/clash $out/bin/clash";
      });
      cpupower-gui = prev.cpupower-gui.overrideAttrs (old: {
        src = inputs.cpupower-gui;
        patches = [];
        postPatch = ''
          substituteInPlace build-aux/meson/postinstall.py \
            --replace '"systemctl"' '"echo", "Skipping:", "systemctl"'
          substituteInPlace data/org.rnd2.cpupower_gui.desktop.in.in \
            --replace "gapplication launch org.rnd2.cpupower_gui" "cpupower-gui"
        '';
      });
      electron = final.yes.lx-music-desktop.electron;
      fcitx5-with-addons = prev.fcitx5-with-addons.overrideAttrs (old: {
        buildCommand = old.buildCommand + ''
          rm $out/$autostart
        '';
      });
      # libreoffice = final.libreoffice-fresh;
      rewine = inputs.rewine.packages.${system};
      # starship = prev.starship.overrideAttrs (old: {
      #   src = inputs.starship;
      #   cargoDeps = final.rustPlatform.importCargoLock {
      #     lockFile = "${inputs.starship}/Cargo.lock";
      #   };
      #   doCheck = false;
      # });
      trackers = inputs.trackers;
      yes = import inputs.yes { pkgs = prev; };
    };
  };
}