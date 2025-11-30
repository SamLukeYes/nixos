{ pkgs, ... }:

{
  imports = [
    ./java
    ./gimp.nix
    ./telegram.nix
    ./vscode.nix
  ];
  
  environment.systemPackages = with pkgs; [
    gnome-frog
    
    # large optional dependencies of GUI applications
    texlive.combined.scheme-full
  ];
}