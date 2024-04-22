{ config, ... }:

{
  users = {
    users.yes = {
      description = "Sam L. Yes";
      extraGroups = [
        "adbusers"
        "aria2"
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
