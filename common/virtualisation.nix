{ config, lib, modulesPath, pkgs, ... }:

{
  virtualisation = {
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
    waydroid.enable = true;

    vmVariant = {
      imports = [ "${modulesPath}/virtualisation/qemu-vm.nix" ];

      networking.hostName = lib.mkForce "test";

      programs.clash-verge.enable = false;

      security = {
        polkit.extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (subject.isInGroup("wheel")) {
              return polkit.Result.YES;
            }
          });
        '';
        sudo.wheelNeedsPassword = false;
      };

      services = {
        cpupower-gui.enable = false;
        openssh = {
          enable = true;
          settings = {
            PermitEmptyPasswords = "yes";
          };
        };
        xserver.displayManager.autoLogin.user = "test";
      };

      system.replaceRuntimeDependencies = let
        qtwayland' = pkgs.qt5.qtwayland.overrideAttrs (old: {
          patches = old.patches ++ [
            (pkgs.fetchpatch {
              url = "https://src.fedoraproject.org/rpms/qt5-qtwayland/raw/rawhide/f/qtwayland-decoration-support-backports-from-qt6.patch";
              hash = "sha256-BmSVhQSJ1IRZujAUbdi9lIM7f59OOQPXctig+w7dri8=";
            })
          ];
        });
        qadwaitadecorations' = pkgs.qadwaitadecorations.override {
          qtwayland = qtwayland';
          qt5ShadowsSupport = true;
        };
      in [
        {
          original = pkgs.qt5.qtwayland;
          replacement = qtwayland';
        }
        {
          original = pkgs.qadwaitadecorations;
          replacement = qadwaitadecorations';
        }
      ];

      users = {
        mutableUsers = false;
        users.test = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" ];
          password = "test";
          shell = pkgs.bashInteractive;
        };
      };

      virtualisation = {
        cores = 2;
        memorySize = 4096;
        qemu.options = [ "-device virtio-vga-gl -display gtk,gl=on" ];
      };
    };
  };
}