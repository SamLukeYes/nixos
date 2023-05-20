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
    flake-utils.follows = "linyinfeng/flake-utils";
    flake-utils-plus.follows = "archix/xddxdd/flake-utils-plus";
    linglong = {
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/linglong-flake";
    };
    linyinfeng = {
      inputs = {
        # flake-utils.follows = "flake-utils";
        # nixos-stable.follows = "nixpkgs-stable";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:linyinfeng/nur-packages";
    };
    # nil = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:oxalica/nil";
    # };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    rewine = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:wineee/nur-packages";
    };
    starship = {
      flake = false;
      url = "github:starship/starship";
    };
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
    # nixpkgs-gnome.url = "github:NixOS/nixpkgs/gnome";
    nixpkgs-stable.follows = "linyinfeng/nixos-stable";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs: 
  let
    # rp = import ./rp.nix;
    system = "x86_64-linux";

  in flake-utils-plus.lib.mkFlake rec {
    inherit self inputs;
    channelsConfig.allowUnfree = true;
    sharedOverlays = [ self.overlays.default ];
    supportedSystems = [ system ];

    channels = {
      # gnome.input = inputs.nixpkgs-gnome;
      nixos-unstable = {
        input = nixpkgs;
        patches = [
          ./patches/pr-232373.patch   # clash-verge
          ./patches/pr-232409.patch   # qq
          ./patches/pr-232928.patch   # clash
        ];
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

      test = {
        # channelName = "gnome";
        modules = [
          ./machines/test

          # experimental linglong support
          inputs.linglong.nixosModules.default
          {
            services.linglong.enable = true;
          }
        ];
      };
    };

    legacyPackages.${system} = import nixpkgs {
      inherit system;
      config = channelsConfig;
      overlays = sharedOverlays;
    };

    overlays.default = final: prev: {
      celluloid = final.callPackage
        "${inputs.nixpkgs-stable}/pkgs/applications/video/celluloid" {};
      cpupower-gui = prev.cpupower-gui.overrideAttrs (old: {
        src = inputs.cpupower-gui;
        patches = [];
        postPatch = ''
          substituteInPlace build-aux/meson/postinstall.py \
            --replace '"systemctl"' '"echo", "Skipping:", "systemctl"'
        '';
      });
      electron = final.yes.lx-music-desktop.electron;
      electron-ncm = final.rewine.electron-netease-cloud-music.override {
        inherit (final) electron;
      };
      libreoffice = final.libreoffice-fresh;
      linyinfeng = inputs.linyinfeng.packages.${system};
      # nil = inputs.nil.packages.${system}.nil;
      rewine = inputs.rewine.packages.${system};
      starship = prev.starship.overrideAttrs (old: {
        src = inputs.starship;
        cargoDeps = final.rustPlatform.importCargoLock {
          lockFile = "${inputs.starship}/Cargo.lock";
        };
        doCheck = false;
      });
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