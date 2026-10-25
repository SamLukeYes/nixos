{ pkgs, ... }:

{
  imports = [
    ./java
    ./gimp.nix
    ./telegram.nix
    ./vscode.nix
  ];
  
  environment.systemPackages = with pkgs; [
    # large optional dependencies of GUI applications
    texliveFull
  ];
}