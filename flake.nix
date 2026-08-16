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

    home-manager = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/home-manager";
    };

    mpv = {
      flake = false;
      url = "github:mpv-player/mpv/fbdaddf9688c6f52e9f2d3d9cf7722d420669574";
    };

    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, archix, nix-index-database, preservation, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      # Patch framework kept as a native flake hook.
      # When the list is empty, the system resolves to the plain flake input.
      # When patches are added, the list is applied to the nixpkgs source tree.
      channel-patches = [
        # Add nixpkgs patches here
        ./patches/waypipe-fix.patch
      ];
      nixpkgs-patched =
        if builtins.length channel-patches == 0
        then nixpkgs
        else nixpkgs.legacyPackages.${system}.applyPatches {
          src = nixpkgs;
          name = "nixpkgs-patched";
          patches = channel-patches;
        };

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
        archix.nixosModules.default
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

      getPkgs = system: import nixpkgs-patched {
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
        comma = prev.comma.override { nix = final.lix; };

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

        mpv-unwrapped = prev.mpv-unwrapped.overrideAttrs (old: {
          src = inputs.mpv;
        });
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
            nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
            ./machines/absolute/configuration.nix
          ];
        };

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

      homeConfigurations."droid" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs-patched {
          system = "aarch64-linux";
          config = channelsConfig;
        };

        modules = [
          nix-index-database.homeModules.default
          { programs.nix-index-database.comma.enable = true; }
          ./machines/nao
        ];

        extraSpecialArgs = {
          inherit inputs;
          inherit nixpkgs-patched;
        };
      };
    };
}
