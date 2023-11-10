{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    onedrive
  ] ++ lib.optional 
    config.services.xserver.desktopManager.gnome.enable
    gnomeExtensions.one-drive-resurrect;
  
  systemd = {
    packages = [ pkgs.onedrive ];
    user.services.onedrive.wantedBy = [ "default.target" ];
  };
}