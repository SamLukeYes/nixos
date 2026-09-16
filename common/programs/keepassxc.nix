{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    keepassxc
    (makeAutostartItem {
      name = "org.keepassxc.KeePassXC";
      package = keepassxc;
    })
  ];

  users.persistence.directories = [
    { directory = ".cache/keepassxc"; mode = "0700"; }
    { directory = ".config/keepassxc"; mode = "0700"; }
  ];
}