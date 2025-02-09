{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.czkawka ];

  users.persistence.directories = [
    ".config/czkawka"
  ];
}