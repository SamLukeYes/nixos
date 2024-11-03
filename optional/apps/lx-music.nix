{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Install in container until its electron version is updated
    # lx-music-desktop
  ];

  networking.firewall.allowedTCPPorts = [ 23332 ];
}