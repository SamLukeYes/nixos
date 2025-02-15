{ ... }:

{
  networking.networkmanager.enable = true;

  preservation.preserveAt."/persistent" = {
    directories = [
      "/var/lib/NetworkManager"
    ];
  };
}