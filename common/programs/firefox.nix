{ config, lib, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-esr;
    languagePacks = [ "zh-CN" ];
    policies = {
      DisableFirefoxAccounts = false;
      DisablePocket = true;
      DisableTelemetry = true;
    };
  };

  environment.variables = {
    BROWSER = lib.getExe config.programs.firefox.package;
    LIBVA_DRIVER_NAME = "iHD";
    MOZ_DBUS_REMOTE = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  users.persistence.directories = [
    ".mozilla"
  ];
}