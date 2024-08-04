{ config, ... }:

{
  services.k3s = {
    enable = true;
    extraFlags = [ "--write-kubeconfig-mode 0644" ];
  };

  systemd.services.k3s.environment = config.networking.proxy.envVars;
}