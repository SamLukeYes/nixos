{ pkgs, ... }:

{
  imports = [
    ./androidsdk.nix
    ./onedrive.nix
  ];

  environment.systemPackages = with pkgs; [
    gnome-frog
    texlive.combined.scheme-full
  ];
}