{ config, lib, ... }:

{
  networking = {
    firewall = rec {
      allowedTCPPorts = [ 23332 ];    # for lx-music sync
      allowedUDPPorts = allowedTCPPorts;
    };
    networkmanager.enable = true;
    proxy.default = lib.mkIf
      config.programs.clash-verge.enable "http://127.0.0.1:7890";
  };
}