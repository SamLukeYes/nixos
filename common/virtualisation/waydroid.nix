{ ... }:

{
  virtualisation.waydroid.enable = true;

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/waydroid"
  ];

  users.persistence.directories = [
    ".local/share/waydroid"
  ];
}