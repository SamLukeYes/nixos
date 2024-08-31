{
  networking = {
    firewall = rec {
      allowedTCPPorts = [
        3389    # for rdp
      ];
      allowedUDPPorts = allowedTCPPorts;
    };
    networkmanager.enable = true;
  };
}