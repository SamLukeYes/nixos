{ config, pkgs, ... }:

{
  programs.xonsh = {
    enable = true;
    package = pkgs.xonsh.override {
      extraPackages = ps: [
        pkgs.yes.xonsh-direnv
      ];
    };
  };

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

      packages = [(pkgs.makeAutostartItem {
        name = "firefox";
        package = config.programs.firefox.package;
      })];
    };
  };
}
