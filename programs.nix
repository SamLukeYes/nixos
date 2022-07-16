{ config, pkgs, ... }:

{
  programs = {

    adb.enable = true;

    git.enable = true;

    gpaste.enable = true;

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    # starship.enable = true;

    xonsh.enable = true;

  };
}
