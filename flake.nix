# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    linglong = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/linglong-flake";
    };
    linyinfeng = {
      inputs = {
        nixos-stable.follows = "nixpkgs-stable";
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
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    # pr-arch-install-scripts.url = "github:SamLukeYes/nixpkgs/arch-install-scripts";
    # pr-pacman.url = "github:SamLukeYes/nixpkgs/pacman";
  };

  # Outputs can be anything, but the wiki + some commands define their own
  # specific keys. Wiki page: https://nixos.wiki/wiki/Flakes#Output_schema
  outputs = { self, nixpkgs, ... }@inputs: 
  let
    # rp = import ./rp.nix;
    system = "x86_64-linux";
    nixpkgs-config = {
      nix.settings.nix-path = [ "nixpkgs=${nixpkgs}" ];
      nixpkgs = {
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      };
    };
    pkgs-stable = import inputs.nixpkgs-stable {
      inherit system;
      inherit (nixpkgs-config.nixpkgs) config;
    };
  in {
    legacyPackages.${system} = import nixpkgs {
      inherit system;
      inherit (nixpkgs-config.nixpkgs) config overlays;
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
      vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          nixpkgs-config
          "${nixpkgs}/nixos/modules/virtualisation/qemu-vm.nix"
          ./machines/vm

          # experimental linglong support
          inputs.linglong.nixosModules
          {
            services.linglong.enable = true;
          }
        ];
      };
    };
    overlays.default = final: prev: {
      # arch-install-scripts = final.callPackage
      #   "${inputs.pr-arch-install-scripts}/pkgs/tools/misc/arch-install-scripts" {};
      devtools = final.yes.archlinux.devtools.override {
        bash = pkgs-stable.bash;
      };
      linyinfeng = inputs.linyinfeng.packages.${system};
      # nil = inputs.nil.packages.${system}.nil;
      # onedrive = prev.onedrive.overrideAttrs (old: rec {
      #   version = "2.4.22";
      #   src = prev.fetchFromGitHub {
      #     owner = "abraunegg";
      #     repo = "onedrive";
      #     rev = "v${version}";
      #     hash = "sha256-KZVRLXXaJYMqHzjxTfQaD0u7n3ACBEk3fLOmqwybNhM=";
      #   };
      # });
      # pacman = final.callPackage
      #   "${inputs.pr-pacman}/pkgs/tools/package-management/pacman" {};
      paru = final.yes.archlinux.paru.override {
        devtools = final.devtools;
      };
      rewine = inputs.rewine.packages.${system};
      trackers = inputs.trackers;
      xournalpp = prev.xournalpp.overrideAttrs (old: {
        src = inputs.xournalpp;
        version = "${old.version}+dev";
        buildInputs = old.buildInputs ++ [ final.alsa-lib ];
      });
      yes = import inputs.yes { pkgs = prev; };
    };
    packages.${system}.default = self.nixosConfigurations.vm.config.system.build.vm;
  };
}