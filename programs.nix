{ config, pkgs, ... }:

{
  programs = {

    adb.enable = true;

    git.enable = true;

    gnupg.agent.enable = true;

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    # starship.enable = true;

    wireshark.enable = true;

    xonsh.enable = true;

  };
}
