# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let rp = (import ./reverse-proxy.nix); in

{
  imports =
    [
      ./boot.nix
      ./environment.nix
      ./i18n.nix
      ./nix.nix
      ./programs.nix
      ./services.nix
      ./system.nix

      # The following files are not tracked by git
      ./hardware-configuration.nix
      ./users.nix
    ];

  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # https://nixos.wiki/wiki/Fonts
  fonts.fonts = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  powerManagement.powertop.enable = true;

  systemd.services.set-energy-preference = {
    wantedBy = ["multi-user.target"];
    description = "Set energy preference to balance power";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "/run/current-system/sw/bin/cpupower-gui ene --pref balance_power";
    };
  };

  # https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  
  # https://nixos.wiki/wiki/Accelerated_Video_Playback
  hardware.opengl = {
    enable = true;
    extraPackages = [ pkgs.intel-media-driver ];
  };

  hardware.sensor.iio.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {

      nur = import (builtins.fetchTarball 
        "${rp}https://github.com/nix-community/NUR/archive/master.tar.gz"
      ) {
        inherit pkgs;
      };
      
      lx-music-desktop = pkgs.callPackage ./lx-music-desktop { inherit rp; };

      xonsh = pkgs.xonsh.overrideAttrs (oldAttrs: rec {
        version = "0.13.0";
        src = pkgs.fetchzip {
          url = "${rp}https://github.com/xonsh/xonsh/releases/download/${version}/xonsh-${version}.tar.gz";
          sha256 = "sha256-8X/+mQrwJ0yaUHRKdoY3G0P8kq22hYfRK+7WRl/zamc=";
        };
        postInstall = ''
          wrapProgram $out/bin/xonsh \
            $makeWrapperArgs
        '';
        disabledTests = oldAttrs.disabledTests ++ [
          "test_ptk_prompt"
          "test_ptk_default_append_history"
          "test_bash_and_is_alias_is_only_functional_alias"
          "test_xonsh_lexer"
          "test_xonsh_activator"
          "test_complete_command"
          "test_skipper_command"
        ];
      });
      
    };
  };

  # qt5.platformTheme = "gnome";

  zramSwap.enable = true;
}

