{
  networking = {
    firewall = rec {
      allowedTCPPorts = [ 23332 ];    # for lx-music sync
      allowedUDPPorts = allowedTCPPorts;
    };
    networkmanager.enable = true;
  };
}