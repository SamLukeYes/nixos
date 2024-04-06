{ ... }:

let
  httpPort = 81;

  # TODO: automatically create this dir with proper permission
  dataDir = "/var/lib/zentao";
in {
  networking.firewall = {
    allowedTCPPorts = [ httpPort ];
    allowedUDPPorts = [ httpPort ];
  };

  virtualisation.oci-containers.containers.zentao = {
    image = "hub.zentao.net/app/zentao:latest";
    environment.MYSQL_INTERNAL = "true";
    ports = [
      "${toString httpPort}:80"
      "3307:3306"
    ];
    volumes = [ "${dataDir}:/data" ];
    extraOptions = [ "--name=zentao" ];
  };
}