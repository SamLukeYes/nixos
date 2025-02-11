{ ... }:

{
  services.fwupd.enable = true;

  environment.persistence."/persistent".directories = [
    "/var/lib/fwupd"
  ];
}