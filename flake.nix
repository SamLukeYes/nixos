# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    archix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:SamLukeYes/archix";
    };

    archlinuxcn-keyring = {
      flake = false;
      url = "github:archlinuxcn/archlinuxcn-keyring";
    };

    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

    mpv = {
      flake = false;
      url = "github:mpv-player/mpv";
    };

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    preservation.url = "github:nix-community/preservation";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs: 
  let
    system = "x86_64-linux";
    channel-patches = [
      # Add nixpkgs patches here
    ];
    nixpkgs-patched =
      flake-utils-plus.lib.patchChannel system nixpkgs channel-patches;

  in flake-utils-plus.lib.mkFlake rec {
    inherit (nixpkgs) lib;
    inherit self inputs;
    channelsConfig = {
      allowlistedLicenses = with lib.licenses; [
        virtualbox-puel
      ];
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "code"
        "vscode"
      ];
    };
    sharedOverlays = [
      self.overlays.default
    ];
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
      specialArgs = { inherit inputs; };
      modules = [
        inputs.archix.nixosModules.default
        inputs.nix-index-database.nixosModules.nix-index

        { environment.etc."nix/inputs/nixpkgs-patched".source = nixpkgs-patched; }

        inputs.preservation.nixosModules.preservation
        self.nixosModules.impermanent-users
      ];
    };

    hosts =  {
      absolute.modules = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
        ./machines/absolute/configuration.nix
      ];
      nixos-iso.modules = [
        ./iso.nix
      ];
    };
    
    defaultPackage.${system} =
      self.nixosConfigurations.nixos-iso.config.system.build.isoImage;

    legacyPackages.${system} = import nixpkgs-patched {
      inherit system;
      config = channelsConfig;
      overlays = sharedOverlays;
    };

    overlays.default = final: prev: {
      archix = import inputs.archix { pkgs = final; };
      archlinuxcn-keyring = inputs.archlinuxcn-keyring;

      gnomeExtensions = prev.gnomeExtensions // {
        # override gnome extensions here
      };

      mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (old: {
        src = inputs.mpv;
      });
    } // lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ./pkgs;
    };

    nixosModules.impermanent-users = import ./modules/impermanent-users.nix;
  };
}