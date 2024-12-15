{ pkgs, ... }:

{
  networking.proxy.default = "http://127.0.0.1:20172";

  services.v2raya = {
    enable = true;
    cliPackage = pkgs.xray;
  };

  systemd.tmpfiles.rules = [
    "f+ /var/log/v2raya/v2raya.log 660 root root"

    # required by xray
    "L+ /root/.local/share/xray/geoip.dat - - - - ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat"
    "L+ /root/.local/share/xray/geosite.dat - - - - ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat"
  ];
}