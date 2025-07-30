# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    angrr = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:linyinfeng/angrr";
    };

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

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # https://github.com/nix-community/preservation/pull/12
    preservation.url = "github:Sporif/preservation/user-paths";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, flake-utils-plus, ... }@inputs: 
  let
    system = "x86_64-linux";
    channel-patches = [
      # Add nixpkgs patches here
      ./patches/audacity-fix.patch
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
      inputs.angrr.overlays.default
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
        inputs.angrr.nixosModules.angrr
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

      # https://github.com/NixOS/nixpkgs/pull/350152
      gnomeExtensions = prev.gnomeExtensions // {
        todotxt = prev.gnomeExtensions.todotxt.overrideAttrs (old: {
          postPatch = ''
            for js in libs/*.js; do
              substituteInPlace $js \
                --replace-quiet "import Clutter from 'gi://Clutter'" "imports.gi.GIRepository.Repository.prepend_search_path('${final.mutter.passthru.libdir}'); const Clutter = (await import('gi://Clutter')).default"
            done
          '';
        });
      };
    } // lib.packagesFromDirectoryRecursive {
      inherit (final) callPackage;
      directory = ./pkgs;
    };

    nixosModules.impermanent-users = import ./modules/impermanent-users.nix;
  };
}