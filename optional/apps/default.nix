{ pkgs, ... }:

{
  imports = [
    ./androidsdk.nix
    ./onedrive.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome-frog
    obs-studio
    texlive.combined.scheme-full
  ];
}