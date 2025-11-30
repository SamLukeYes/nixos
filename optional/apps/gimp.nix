{ lib, pkgs, ... }:

{
  environment.systemPackages = lib.mkAfter [ pkgs.gimp3 ];

  users.persistence.directories = [
    ".config/GIMP"
  ];
}