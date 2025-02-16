{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.trashy ];

  users.persistence.directories = [
    ".local/share/Trash"
  ];
}