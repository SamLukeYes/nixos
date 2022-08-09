{ config, pkgs, ... }:

{
  systemd = {
    nspawn.old-root.networkConfig.Private = false;
  };
}