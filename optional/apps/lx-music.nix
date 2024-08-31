{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lx-music-desktop
  ];

  networking.firewall.allowedTCPPorts = [ 23332 ];
}