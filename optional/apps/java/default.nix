{ pkgs, ... }:

{
  imports = [
    ./tomcat.nix
  ];

  environment.systemPackages = with pkgs; [
    charles
    xmind
    yes.ludii

    # CLI tools
    pdftk                         # required by Jasminum
  ];

  programs.java.enable = true;
}