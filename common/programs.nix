{ config, pkgs, ... }:

{
  programs = {

    adb.enable = true;

    command-not-found.enable = false;

    git.enable = true;

    gnupg.agent.enable = true;

    wireshark.enable = true;

    xonsh.enable = true;

  };
}
