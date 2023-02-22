{ lib, pkgs, ... }:

{
  imports = [
    ../../common
    ../../users/yes
  ];

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
    xserver.displayManager.autoLogin = {
      enable = true;
      user = "yes";
    };
  };

  system.stateVersion = "23.05";

  virtualisation = {
    cores = 2;
    memorySize = 4096;
    qemu.options = [ "-device virtio-vga-gl -display sdl,gl=on" ];
    sharedDirectories.download = {
      source = "/home/yes/Downloads";
      target = "/home/yes/Downloads";
    };
  };
}