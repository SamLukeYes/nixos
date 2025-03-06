{ ... }:

{
  programs.firefox = {
    enable = true;
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