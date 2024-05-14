{ config, pkgs, ... }:

{
  programs = {
    adb.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  services.jenkins = {
    enable = true;
    packages = with config; [
      nix.package
      programs.git.package
      programs.java.package
      programs.ssh.package
    ];
    port = 8083;
    user = "yes";
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
