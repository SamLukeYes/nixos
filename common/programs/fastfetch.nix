{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.fastfetch ];

  users.persistence.directories = [
    ".local/share/fastfetch"
  ];
}