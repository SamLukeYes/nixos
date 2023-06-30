# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    archix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/archix";
    };
    cpupower-gui = {
      flake = false;
      url = "github:vagnum08/cpupower-gui";
    };
    flake-utils.follows = "archix/xddxdd/flake-utils";
    flake-utils-plus.follows = "archix/xddxdd/flake-utils-plus";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
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
    xournalpp = {
      flake = false;
      url = "github:xournalpp/xournalpp";
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
      ./patches/240246.patch
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
      ];
    };

    hosts = {
      absolute.modules = [
        inputs.archix.nixosModules.binfmt
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
        ./machines/absolute/configuration.nix
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
      cpupower-gui = prev.cpupower-gui.overrideAttrs (old: {
        src = inputs.cpupower-gui;
        patches = [];
        postPatch = ''
          substituteInPlace build-aux/meson/postinstall.py \
            --replace '"systemctl"' '"echo", "Skipping:", "systemctl"'
        '';
      });
      electron = final.yes.lx-music-desktop.electron;
      flatpak = prev.flatpak.overrideAttrs (old: {
        configureFlags = old.configureFlags ++ [
          "--with-system-fonts-dir=/run/current-system/sw/share/X11/fonts"
        ];
      });
      libreoffice = final.libreoffice-fresh;
      rewine = inputs.rewine.packages.${system};
      # starship = prev.starship.overrideAttrs (old: {
      #   src = inputs.starship;
      #   cargoDeps = final.rustPlatform.importCargoLock {
      #     lockFile = "${inputs.starship}/Cargo.lock";
      #   };
      #   doCheck = false;
      # });
      trackers = inputs.trackers;
      xournalpp = prev.xournalpp.overrideAttrs (old: {
        src = inputs.xournalpp;
        version = "${old.version}+dev";
        buildInputs = old.buildInputs ++ [ final.alsa-lib ];
      });
      yes = import inputs.yes { pkgs = prev; };
    };
  };
}