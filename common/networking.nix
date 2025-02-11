{ ... }:

{
  networking.networkmanager.enable = true;

  environment.persistence."/persistent" = {
    directories = [
      "/var/lib/NetworkManager"
    ];
  };
}