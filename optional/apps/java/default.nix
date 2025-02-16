{ ... }:

{
  imports = [
    ./charles.nix
    ./shimeji.nix
  ];

  programs.java.enable = true;
}