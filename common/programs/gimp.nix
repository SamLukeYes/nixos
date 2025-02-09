{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.gimp ];

  users.persistence.directories = [
    ".config/GIMP"
  ];
}