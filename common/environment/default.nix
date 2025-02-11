{ config, lib, pkgs, ... }:

{
  imports = [
    ./impermanence.nix
    ./python.nix
    ./systemPackages.nix
  ];

  environment = {
    extraSetup = lib.optionalString (!config.services.printing.enable) ''
      rm $out/share/applications/cups.desktop
    '';

    homeBinInPath = true;

    variables = {
      BASH_COMPLETIONS = ["${pkgs.bash-completion}/share/bash-completion/bash_completion"];
      BROWSER = lib.getExe config.programs.firefox.package;
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_DBUS_REMOTE = "1";
      MOZ_USE_XINPUT2 = "1";
      NIXOS_OZONE_WL = "1";
      TZ = "/etc/localtime";
    };
  };
}
