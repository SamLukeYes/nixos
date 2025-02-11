{ lib, modulesPath, pkgs, ... }:

{
  virtualisation = {
    vmVariant = {
      imports = [
        "${modulesPath}/virtualisation/qemu-vm.nix"
      ];

      environment = {
        etc."xonsh/xonshrc".text = lib.mkForce "";
        systemPackages = with pkgs; [
          xorg.xeyes
        ];
      };

      networking = {
        hostName = lib.mkForce "test";
        proxy.default = lib.mkForce null;
      };

      programs.xonsh.config = lib.mkForce "";

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
        journald.storage = "volatile";
        mihomo.enable = lib.mkForce false;
        openssh.enable = true;
        thinkfan.enable = lib.mkForce false;
      };

      swapDevices = lib.mkForce [];

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
        qemu.options = [ "-device virtio-vga-gl -display sdl,gl=on" ];
      };
    };
  };
}