{ config, pkgs, ... }:

{
  programs = {
    adb.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "yes";
    dataDir = "/home/yes";
  };

  users = {
    groups.yes.gid = 1000;
    users.yes = {
      description = "Sam L. Yes";
      group = "yes";
      extraGroups = [
        "adbusers"
        "networkmanager"
        "wheel"
        "wireshark"
      ];
      initialHashedPassword = "";
      isNormalUser = true;
      shell = config.programs.xonsh.package;
      uid = 1000;
    };
  };
}
