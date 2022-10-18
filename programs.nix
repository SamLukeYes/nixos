{ config, pkgs, ... }:

{
  programs = {

    adb.enable = true;

    git.enable = true;

    gnupg.agent.enable = true;

    wireshark.enable = true;

    xonsh.enable = true;

  };
}
