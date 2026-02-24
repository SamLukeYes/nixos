{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.ppsspp-sdl-wayland ];

  users.persistence.directories = [
    ".config/ppsspp"
  ];
}