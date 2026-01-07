{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.android-tools ];

  users.persistence.directories = [
    ".android"
  ];
}