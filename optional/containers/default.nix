{ config, ... }:

{
  services.k3s.enable = true;
  systemd.services.k3s.environment = config.networking.proxy.envVars;
}