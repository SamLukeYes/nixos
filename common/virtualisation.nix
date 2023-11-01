{ lib, modulesPath, pkgs, ... }:

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

      # system.replaceRuntimeDependencies = [({
      #   original = pkgs.qt5.qtwayland;
      #   replacement = pkgs.qtwayland-patched;
      # })];

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