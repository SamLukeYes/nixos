{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # large optional dependencies of GUI applications
    tesseract
    texlive.combined.scheme-full
  ];
}