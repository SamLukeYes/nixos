{ pkgs, ... }:

{
  imports = [
    ./java
    ./lx-music.nix
    ./quickemu.nix
  ];
  
  environment.systemPackages = with pkgs; [
    gnome-frog
    upscayl
    zotero
    
    # large optional dependencies of GUI applications
    texlive.combined.scheme-full
  ];
}