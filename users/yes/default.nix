{config, pkgs, ...}:

{
  users = {
    users.yes = {
      description = "Sam L. Yes";
      extraGroups = ["wheel" "aria2" "adbusers" "networkmanager" "wireshark"];
      isNormalUser = true;
      shell = pkgs.xonsh;
      uid = 1000;
    };
  };
}
