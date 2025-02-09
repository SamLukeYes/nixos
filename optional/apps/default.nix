{ pkgs, ... }:

{
  imports = [
    ./java
  ];
  
  environment.systemPackages = with pkgs; [
    gnome-frog
    
    # large optional dependencies of GUI applications
    texlive.combined.scheme-full
  ];
}