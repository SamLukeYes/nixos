{
  networking = {
    firewall = rec {
      allowedTCPPorts = [
        2425    # for iptux
        8787    # make shadowsocks-ws available to other devices
        23332   # for lx-music sync
      ];
      allowedUDPPorts = allowedTCPPorts;
    };
    networkmanager.enable = true;
  };
}