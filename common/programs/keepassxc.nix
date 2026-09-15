{ pkgs, ... }:

{
  environment.systemPackages = [
    pkgs.keepassxc
  ];

  users.persistence.directories = [
    { directory = ".config/keepassxc"; mode = "0700"; }
  ];
}