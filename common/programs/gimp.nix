{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gimp3 ];

  users.persistence.directories = [
    ".config/GIMP"
  ];
}