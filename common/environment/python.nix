{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.conda ];

  users.persistence.directories = [
    ".conda"
    ".config/pip"
  ];
}