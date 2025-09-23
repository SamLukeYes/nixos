{ pkgs, ... }:

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

  users.persistence.directories = [
    ".mozilla"
  ];
}