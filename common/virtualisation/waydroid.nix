{ ... }:

{
  virtualisation.waydroid.enable = true;

  networking.nftables.enable = true;

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/waydroid"
  ];

  users.persistence.directories = [
    ".local/share/waydroid"
  ];
}