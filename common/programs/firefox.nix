{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    package = pkgs.librewolf;
    policies = {
      DisableFirefoxAccounts = false;
      DisablePocket = true;
      DisableTelemetry = true;
    };
  };

  users.persistence.directories = [
    ".librewolf"
  ];
}