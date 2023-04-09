# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    cpupower-gui = {
      flake = false;
      url = "github:vagnum08/cpupower-gui";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils-plus = {
      inputs.flake-utils.follows = "flake-utils";
      url = "github:gytis-ivaskevicius/flake-utils-plus";
    };
    linglong = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/linglong-flake";
    };
    linyinfeng = {
      inputs = {
        flake-utils.follows = "flake-utils";
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
    olex2 = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/olex2-flake";
    };
    rewine = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:wineee/nur-packages";
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
    # nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
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
        patches = [ ];
      };
    };

    hostDefaults = {
      inherit system;
      channelName = "nixos-unstable";
      modules = [
        {
          nix = {
            generateNixPathFromInputs = true;
            generateRegistryFromInputs = true;
            linkInputs = true;
          };
        }
      ];
    };

    hosts = {
      absolute.modules = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
        ./machines/absolute/configuration.nix
      ];

      test = {
        # channelName = "gnome";
        modules = [
          "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ./machines/test

          # experimental linglong support
          inputs.linglong.nixosModules
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
      cpupower-gui = prev.cpupower-gui.overrideAttrs (old: {
        src = inputs.cpupower-gui;
        patches = [];
        postPatch = ''
          substituteInPlace build-aux/meson/postinstall.py \
            --replace '"systemctl"' '"echo", "Skipping:", "systemctl"'
        '';
      });
      devtools = final.yes.archlinux.devtools;
      linyinfeng = inputs.linyinfeng.packages.${system};
      # nil = inputs.nil.packages.${system}.nil;
      olex2 = inputs.olex2.packages.${system}.olex2-launcher-x11;
      paru = final.yes.archlinux.paru;
      rewine = inputs.rewine.packages.${system};
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