{ modulesPath, ... }:

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
      };

      users.mutableUsers = false;

      virtualisation = {
        cores = 2;
        memorySize = 4096;
        qemu.options = [ "-device virtio-vga-gl -display sdl,gl=on" ];
      };
    };
  };
}