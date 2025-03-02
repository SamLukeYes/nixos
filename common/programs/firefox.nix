{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    package = pkgs.librewolf;
    policies = {
      DisableAppUpdate = true;
      DisablePocket = true;
      DisableTelemetry = true;
    };
  };

  users.persistence.directories = [
    ".librewolf"
  ];
}