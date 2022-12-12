# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    # nil = {
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   url = "github:oxalica/nil";
    # };
    nixos-cn = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nixos-cn/flakes";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    rewine = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:wineee/nur-packages";
    };
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
    # pr-arch-install-scripts.url = "github:SamLukeYes/nixpkgs/arch-install-scripts";
    pr-onedrive.url = "github:r-ryantm/nixpkgs/auto-update/onedrive";
    # pr-pacman.url = "github:SamLukeYes/nixpkgs/pacman";
    pr-pano.url = "github:michojel/nixpkgs/gnome-shell-extension-pano";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, ... }@inputs: 
  let
    system = "x86_64-linux";
    overlay = final: prev: {
      # arch-install-scripts = final.callPackage
      #   "${inputs.pr-arch-install-scripts}/pkgs/tools/misc/arch-install-scripts" {};
      # gnome = prev.gnome.overrideScope' (self: super: {
      #   gnome-keyring = inputs.glib_2_74_0.legacyPackages.${system}.gnome.gnome-keyring;
      # });
      # nil = inputs.nil.packages.${system}.nil;
      nixos-cn = inputs.nixos-cn.legacyPackages.${system};
      onedrive = final.callPackage
        "${inputs.pr-onedrive}/pkgs/applications/networking/sync/onedrive" {};
      # pacman = final.callPackage
      #   "${inputs.pr-pacman}/pkgs/tools/package-management/pacman" {};
      pano = final.callPackage
        "${inputs.pr-pano}/pkgs/desktops/gnome/extensions/pano" {};
      rewine = inputs.rewine.packages.${system};
      trackers = inputs.trackers;
      yes = import inputs.yes {
        pkgs = prev;
        # rp = import ./rp.nix;
      };
    };
    nixpkgs-config = {
      nix.settings.nix-path = [ "nixpkgs=${nixpkgs}" ];
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [ overlay ];
      };
    };
  in {
    legacyPackages.${system} = import nixpkgs {
      inherit system;
      overlays = [ overlay ];
    };
    nixosConfigurations = {
      absolute = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixpkgs-config
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
          ./machines/absolute/configuration.nix
        ];
      };
    };
  };
}