{ pkgs, ... }:

{
  imports = [
    ./java
  ];
  
  environment.systemPackages = with pkgs; [
    gnome-frog
    zotero
    
    # large optional dependencies of GUI applications
    texlive.combined.scheme-full
  ];
}