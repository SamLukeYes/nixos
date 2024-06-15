# Based on https://gist.github.com/m1cr0man/8cae16037d6e779befa898bfefd36627

{
  description = "My NixOS configuration";

  inputs = {
    angrr = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:linyinfeng/angrr";
    };
    archix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        xddxdd.follows = "xddxdd";
      };
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
    flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";
    nix-index-database = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-index-database";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    rewine = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:wineee/nur-packages";
    };
    xddxdd = {
      inputs = {
        nix-index-database.follows = "nix-index-database";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:xddxdd/nur-packages";
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
      ./patches/314728.patch    # xonsh
    ];
    nixpkgs-patched =
      flake-utils-plus.lib.patchChannel system nixpkgs channel-patches;

  in flake-utils-plus.lib.mkFlake rec {
    inherit self inputs;
    channelsConfig = {
      allowUnfree = true;
      android_sdk.accept_license = true;
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
      modules = [
        inputs.angrr.nixosModules.angrr
        inputs.archix.nixosModules.default
        inputs.nix-index-database.nixosModules.nix-index
        { nix.settings.nix-path = ["nixpkgs=${nixpkgs-patched}"]; }
      ];
    };

    hosts = let
      absolute-modules = [
        inputs.archix.nixosModules.binfmt
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
    
    defaultPackage.${system} =
      self.nixosConfigurations.nixos-iso.config.system.build.isoImage;

    legacyPackages.${system} = import nixpkgs-patched {
      inherit system;
      config = channelsConfig;
      overlays = sharedOverlays;
    };

    overlays.default = final: prev: {
      androidPkgs = final.androidenv.androidPkgs_9_0;
      android-tools = final.androidPkgs.androidsdk;
      archix = import inputs.archix { pkgs = final; };
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
      paru = final.archix.paru;
      rewine = import inputs.rewine { pkgs = final; };
      yes = import inputs.yes { pkgs = final; };
      zotero = final.zotero_7;
    };
  };
}