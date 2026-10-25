{ config, lib, ... }:

{
  preservation = {
    enable = lib.mkDefault true;
    preserveAt."/persistent" = {
      directories = [
        { directory = "/etc"; inInitrd = true; }
        { directory = "/nix"; inInitrd = true; }
        { directory = "/var/lib/nixos"; inInitrd = true; }
        { directory = "/var/lib/private"; inInitrd = true; }
        "/var/log/journal"
        "/root/.ssh"
      ];
    };
  };

  fileSystems."/" = lib.mkIf config.preservation.enable {
    fsType = "tmpfs";
    options = [ "size=90%" "mode=755" ];
  };
}