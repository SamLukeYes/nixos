{ config, pkgs, ... }:

{
  programs = {

    adb.enable = true;

    command-not-found.enable = false;

    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      package = pkgs.firefox-esr;
    };

    git.enable = true;

    gnupg.agent.enable = true;

    nix-index.enable = true;

    wireshark.enable = true;

    xonsh.enable = true;

  };
}
