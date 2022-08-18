{ config, pkgs, ... }:

{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [(import ./overlays.nix)];
  };
}