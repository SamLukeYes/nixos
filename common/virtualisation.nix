{ lib, modulesPath, pkgs, ... }:

{
  virtualisation = {
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };

    vmVariant = {
      imports = [
        "${modulesPath}/virtualisation/qemu-vm.nix"
      ];

      # boot.kernelPackages = pkgs.linuxPackages_xanmod;

      environment.systemPackages = with pkgs; [
        qt5ct
        qt6ct
        xorg.xeyes
      ];

      networking = {
        hostName = lib.mkForce "test";
        proxy.default = lib.mkForce null;
      };

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
        journald.storage = "volatile";
        openssh = {
          enable = true;
          # settings = {
          #   PermitEmptyPasswords = "yes";
          # };
        };
        thinkfan.enable = lib.mkForce false;
        # xserver.displayManager.autoLogin.user = "test";
      };

      systemd.targets.machines.enable = false;

      users = {
        mutableUsers = false;

        # test user with default login shell
        users.test = {
          isNormalUser = true;
          extraGroups = [ "wheel" "networkmanager" ];
          password = "test";
          shell = pkgs.bashInteractive;
        };
      };

      virtualisation = {
        cores = 2;
        diskSize = 8192;
        memorySize = 4096;
        qemu.options = [ "-device virtio-vga-gl -display gtk,gl=on" ];
        virtualbox.host.enable = lib.mkForce false;
      };
    };
  };
}