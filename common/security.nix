{ ... }:

{
  # use run0-sudo-shim
  security = {
    run0-sudo-shim.enable = true;
    polkit.persistentAuthentication = true;
  };
}