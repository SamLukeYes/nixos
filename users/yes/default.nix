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
        "vboxusers"
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

  virtualisation.virtualbox.host = {
    enable = true;
    enableKvm = true;

    # required by enableKvm for now
    addNetworkInterface = false;
  };
}
