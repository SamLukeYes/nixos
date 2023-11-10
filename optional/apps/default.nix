{ pkgs, ... }:

{
  imports = [
    ./onedrive.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome-frog
    obs-studio
    texlive.combined.scheme-full
  ];
}