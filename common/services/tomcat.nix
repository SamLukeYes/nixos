let
  port = 8080;
in {
  networking.firewall = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };
  services.tomcat.enable = true;
}