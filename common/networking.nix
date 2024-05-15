{
  networking = {
    firewall = rec {
      allowedTCPPorts = [
        2425    # for iptux
        3389    # for rdp
        23332   # for lx-music sync
      ];
      allowedUDPPorts = allowedTCPPorts;

      allowedTCPPortRanges = [{
        from = 8080;
        to = 8089;
      }];
      allowedUDPPortRanges = allowedTCPPortRanges;
    };
    networkmanager.enable = true;
  };
}