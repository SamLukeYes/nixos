{
  users.users.yes = {
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
    uid = 1000;
  };
}
