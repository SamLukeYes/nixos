{config, pkgs, ...}:

{
  users = {
    defaultUserShell = pkgs.xonsh;
    users.yes = {
      uid = 1000;
      description = "Sam L. Yes";
      extraGroups = ["wheel" "aria2" "adbusers" "networkmanager" "wireshark"];
      isNormalUser = true;
    };
  };
}
