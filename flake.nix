# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    archix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/archix";
    };
    archlinuxcn-keyring = {
      flake = false;
      url = "github:archlinuxcn/archlinuxcn-keyring";
    };
    cpupower-gui = {
      flake = false;
      url = "github:vagnum08/cpupower-gui";
    };
    flake-utils.follows = "archix/xddxdd/flake-utils";
    flake-utils-plus.follows = "archix/xddxdd/flake-utils-plus";
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
    system = "x86_64-linux";
    channel-patches = [
      # Add nixpkgs patches here
      ./patches/nixos-rebuild-use-nom.patch
      ./patches/274140.patch    # system-monitor-next
      ./patches/274499.patch    # vscode
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
        inputs.archix.nixosModules.binfmt
      ];
    };

    hosts = let
      absolute-modules = [
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l13-yoga
        ./machines/absolute/configuration.nix
      ];
    in {
      absolute-gnome.modules = absolute-modules ++ [
        ./optional/desktop/gnome.nix
      ];
      absolute-plasma.modules = absolute-modules ++ [
        ./optional/desktop/plasma.nix
      ];
      nixos-iso.modules = [
        ./iso.nix
      ];
    };
    
    iso = self.nixosConfigurations.nixos-iso.config.system.build.isoImage;

    legacyPackages.${system} = import (
      flake-utils-plus.lib.patchChannel system nixpkgs channel-patches
    ) {
      inherit system;
      config = channelsConfig;
      overlays = sharedOverlays;
    };

    overlays.default = final: prev: {
      archix = inputs.archix.packages.${system};
      archlinuxcn-keyring = inputs.archlinuxcn-keyring;
      cpupower-gui = prev.cpupower-gui.overrideAttrs (old: {
        src = inputs.cpupower-gui;
        patches = [];
        postPatch = ''
          substituteInPlace build-aux/meson/postinstall.py \
            --replace '"systemctl"' '"echo", "Skipping:", "systemctl"'
          substituteInPlace data/org.rnd2.cpupower_gui.desktop.in.in \
            --replace "gapplication launch org.rnd2.cpupower_gui" "cpupower-gui"
        '';
      });
      electron_25-bin = prev.electron_25-bin.overrideAttrs (old: rec {
        version = "25.9.8";
        src = final.fetchurl {
          url = "https://github.com/electron/electron/releases/download/v${version}/electron-v${version}-linux-x64.zip";
          sha256 = "c77fec4d32d473f75611c76ef46d947da253821a64e48edf70dafb120b434752";
        };
        meta = old.meta // {
          knownVulnerabilities = [];
        };
      });
      fcitx5-with-addons = prev.fcitx5-with-addons.overrideAttrs (old: {
        buildCommand = old.buildCommand + ''
          rm $out/$autostart
        '';
      });
      # libreoffice = final.libreoffice-fresh;
      rewine = inputs.rewine.packages.${system};
      # starship = prev.starship.overrideAttrs (old: {
      #   src = inputs.starship;
      #   cargoDeps = final.rustPlatform.importCargoLock {
      #     lockFile = "${inputs.starship}/Cargo.lock";
      #   };
      #   doCheck = false;
      # });
      trackers = inputs.trackers;
      yes = import inputs.yes { pkgs = prev; };
      zotero = prev.zotero.overrideAttrs (old: rec {
        version = "7.0.0-beta.53%2B969031a37";
        src = final.fetchurl {
          url = "https://download.zotero.org/client/beta/${version}/Zotero-${version}_linux-x86_64.tar.bz2";
          hash = "sha256-Tnb5t7owzzRMqhRD19QLcVJe/cc2/0QATJXDcZZPP+s=";
        };
        libPath = with final; old.libPath + ":" + lib.makeLibraryPath [
          alsa-lib xorg.libXtst
        ];
        postPatch = "";
      });
    };
  };
}