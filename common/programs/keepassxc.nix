{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.keepassxc
  ];

  users.persistence.directories = [
    { directory = ".cache/keepassxc"; mode = "0700"; }
    { directory = ".config/keepassxc"; mode = "0700"; }
  ];
}