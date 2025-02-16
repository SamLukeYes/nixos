{ ... }:

{
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/containers"
  ];

  users.persistence.directories = [
    ".local/share/containers"
  ];
}