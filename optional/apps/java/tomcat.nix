{ config, lib, ... }:

{
  services.tomcat = {
    enable = true;
    webapps = [];
  };

  # Use port 8082 instead of 8080
  systemd.services.tomcat.preStart = lib.mkAfter ''
    sed -i "s/8080/8082/" ${config.services.tomcat.baseDir}/conf/server.xml
  '';
}