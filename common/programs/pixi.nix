{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.pixi ];

  users.persistence.directories = [
    ".pixi"
  ];
}