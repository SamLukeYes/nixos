{ ... }:

{
  services.fwupd.enable = true;

  preservation.preserveAt."/persistent".directories = [
    "/var/lib/fwupd"
  ];
}