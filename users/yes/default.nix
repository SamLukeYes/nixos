{config, pkgs, ...}:

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
      isNormalUser = true;
      shell = pkgs.xonsh;
      uid = 1000;
    };
  };
}
