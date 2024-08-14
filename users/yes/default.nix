{ config, pkgs, ... }:

{
  programs = {
    adb.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  users = {
    users.yes = {
      description = "Sam L. Yes";
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

      packages = with pkgs; [
        seafile-client
        (makeAutostartItem {
          name = "seafile";
          package = seafile-client;
        })
      ];
    };
  };
}
