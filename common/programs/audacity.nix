{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.audacity ];

  users.persistence.directories = [
    ".config/audacity"
    ".local/share/audacity"
  ];
}