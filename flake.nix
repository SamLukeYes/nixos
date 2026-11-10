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

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };

    nixos-avf = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/nixos-avf-koiTerminal/nixos-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";
  };

  outputs = { self, nixpkgs, nixos-hardware, archix, nix-index-database, preservation, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      # Patch framework kept as a native flake hook.
      # When the list is empty, the system resolves to the plain flake input.
      # When patches are added, the list is applied to the nixpkgs source tree.
      channel-patches = [
        # Add nixpkgs patches here
      ];
      
      getPatchedNixpkgs = system:
        if builtins.length channel-patches == 0
        then nixpkgs
        else nixpkgs.legacyPackages.${system}.applyPatches {
          src = nixpkgs;
          name = "nixpkgs-patched";
          patches = channel-patches;
        };

      nixpkgs-patched = getPatchedNixpkgs system;

      channelsConfig = {
        allowlistedLicenses = with lib.licenses; [
          virtualbox-puel
        ];
        allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
          "code"
          "vscode"
        ];
      };

      commonModules = [
        nix-index-database.nixosModules.nix-index
        {
          time.timeZone = "Asia/Shanghai";
          system.stateVersion = "26.05";

          nix.registry = {
            nixpkgs.to = {
              type = "path";
              path = nixpkgs;
            };
            nixpkgs-patched.to = {
              type = "path";
              path = nixpkgs-patched;
            };
          };
        }
        preservation.nixosModules.preservation
        self.nixosModules.impermanent-users
      ];

      getPkgs = system: import (getPatchedNixpkgs system) {
        inherit system;
        config = channelsConfig;
        overlays = [ self.overlays.default ];
      };

      pkgs = getPkgs system;
    in
    {
      legacyPackages.${system} = pkgs;

      defaultPackage.${system} =
        self.nixosConfigurations.nixos-iso.config.system.build.isoImage;

      overlays.default = final: prev: {
        archix = import archix { pkgs = final; };
        archlinuxcn-keyring = inputs.archlinuxcn-keyring;
        # comma = prev.comma.override { nix = final.lix; };

        gnomeExtensions = prev.gnomeExtensions // {
          # override gnome extensions here
        };

        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (
            python-final: python-prev: {
              vulkan = python-prev.vulkan.overridePythonAttrs (oldAttrs: {
                dependencies = [ python-final.cffi ];
              });
            }
          )
        ];
      } // lib.packagesFromDirectoryRecursive {
        inherit (final) callPackage;
        directory = ./pkgs;
      };

      nixosModules.impermanent-users = import ./modules/impermanent-users.nix;

      nixosConfigurations = {
        absolute = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = commonModules ++ [
            archix.nixosModules.default
            nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
            ./machines/absolute/configuration.nix
          ];
        };

        nao = nixpkgs.lib.nixosSystem (let
          system = "aarch64-linux";
        in {
          inherit system;
          pkgs = getPkgs system;
          modules = commonModules ++ [
            inputs.nixos-avf.nixosModules.avf
            ./machines/nao/configuration.nix
          ];
        });

        nixos-iso = nixpkgs.lib.nixosSystem {
          inherit system pkgs;
          specialArgs = {
            inherit inputs;
          };
          modules = commonModules ++ [
            ./iso.nix
          ];
        };
      };
    };
}
