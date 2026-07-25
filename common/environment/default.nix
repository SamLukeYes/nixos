{ ... }:

{
  imports = [
    ./systemPackages.nix
    ./trash.nix
  ];

  environment = {
    defaultPackages = [];

    variables = {
      NIXOS_OZONE_WL = "1";
      TZ = "/etc/localtime";
    };
  };
}
