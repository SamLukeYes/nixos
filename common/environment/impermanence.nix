{ ... }:

{
  environment.persistence."/persistent" = {
    directories = [
      "/etc"
      "/nix"
      "/var/lib/nixos"
      "/var/lib/private"
      "/var/log/journal"
    ];
  };

  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "size=90%" "mode=755" ];
  };
}