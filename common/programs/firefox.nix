{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    package = pkgs.librewolf;
  };

  users.persistence.directories = [
    ".librewolf"
  ];
}