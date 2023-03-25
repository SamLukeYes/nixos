{ pkgs, ... }:

{
  programs.xonsh.enable = true;
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
      initialHashedPassword = "";
      isNormalUser = true;
      shell = pkgs.xonsh;
      uid = 1000;
    };
  };
}
