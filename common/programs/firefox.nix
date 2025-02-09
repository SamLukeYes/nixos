{ ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    policies.DisableAppUpdate = true;
  };

  users.persistence.directories = [
    ".mozilla"
  ];
}