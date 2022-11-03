# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = rec {
    nixos-cn.url = "github:nixos-cn/flakes";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    rewine.url = "github:wineee/nur-packages";
    xddxdd.url = "github:xddxdd/nur-packages";
    yes = {
      url = "github:SamLukeYes/nix-custom-packages";
      flake = false;
    };

    # nixpkgs
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    pr-pano.url = "github:michojel/nixpkgs/gnome-shell-extension-pano";
    nixpkgs = nixos-unstable;
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
    nixpkgs-config = {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            firefox = final.firefox-esr-wayland;
            pano = final.callPackage (
              inputs.pr-pano + "/pkgs/desktops/gnome/extensions/pano"
            ) {};
            nixos-cn = inputs.nixos-cn.legacyPackages.${system};
            rewine = inputs.rewine.packages.${system};
            xddxdd = inputs.xddxdd.packages.${system};
            yes = import inputs.yes {
              pkgs = prev;
              rp = import ./rp.nix;
            };
          })
        ];
      };
    };
  in {
    # nixosConfigurations is the key that nixos-rebuild looks for.
    nixosConfigurations = {
      absolute = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixpkgs-config
          inputs.nixos-cn.nixosModules.nixos-cn-registries
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
          ./machines/absolute/configuration.nix
        ];
      };
    };
  };
}