{ pkgs, ... }:

{
  imports = [
    ./java
    ./quickemu.nix
  ];
  
  environment.systemPackages = with pkgs; [
    gnome-frog
    zotero
    
    # large optional dependencies of GUI applications
    texlive.combined.scheme-full
  ];
}