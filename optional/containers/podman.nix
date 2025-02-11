{ ... }:

{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };

  environment.persistence."/persistent".directories = [
    "/var/lib/containers"
  ];
}