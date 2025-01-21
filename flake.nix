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
    shimeji = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:SamLukeYes/Shimeji-Desktop";
    };
    zzzsyyy = {
      flake = false;  # too many dependencies, but I only want their overlay
      url = "github:zzzsyyy/flakes";
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
      ./patches/375009.patch  # xonsh
      ./patches/354733.patch  # xontribs
    ];
    nixpkgs-patched =
      flake-utils-plus.lib.patchChannel system nixpkgs channel-patches;

  in flake-utils-plus.lib.mkFlake rec {
    inherit (nixpkgs) lib;
    inherit self inputs;
    channelsConfig = {
      allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        "charles"
        "code"
        "vscode"
      ];
    };
    sharedOverlays = [
      (import "${inputs.zzzsyyy}/overlays/mutter.nix")
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
        { environment.etc."nix/inputs/nixpkgs-patched".source = nixpkgs-patched; }
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

      celluloid = prev.celluloid.overrideAttrs (old: {
        src = final.fetchFromGitHub {
          owner = "celluloid-player";
          repo = "celluloid";
          rev = "efc1e4e6c33b7a6684090ffa20bf75a070171cf6";
          hash = "sha256-8mmfLhHUDQyGaTPuFGqhNmwRo0LpIkTNdZIaIGCKds8=";
        };
      });

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

      jdk = final.jetbrains.jdk-no-jcef;
      shimeji = inputs.shimeji.packages.${system};
    };
  };
}