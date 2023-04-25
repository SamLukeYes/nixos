{ config, pkgs, ... }:

{
  programs.xonsh = {
    enable = true;
    package = pkgs.xonsh.overrideAttrs (oldAttrs: {
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs ++ (with pkgs; [
        yes.xonsh-direnv
      ]);
    });
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
      initialHashedPassword = "";
      isNormalUser = true;
      shell = config.programs.xonsh.package;
      uid = 1000;
    };
  };
}
