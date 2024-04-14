{
  networking.firewall = rec {
    allowedTCPPorts = [ 8080 8081 ];
    allowedUDPPorts = allowedTCPPorts;
  };
  services.tomcat = {
    enable = true;
    webapps = [];
  };
}