{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.authenticator ];

  users.persistence.directories = [
    ".cache/authenticator/favicons"
    ".local/share/authenticator"
  ];
}