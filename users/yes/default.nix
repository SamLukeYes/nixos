{ config, ... }:

{
  users = {
    users.yes = {
      description = "Sam L. Yes";
      extraGroups = [
        "adbusers"
        "aria2"
        "libvirtd"
        "networkmanager"
        "wheel"
        "wireshark"
      ];
      initialPassword = "";
      isNormalUser = true;
      shell = config.programs.xonsh.package;
      uid = 1000;
    };
  };
}
