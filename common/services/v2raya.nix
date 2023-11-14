{
  networking.proxy.default = "http://127.0.0.1:20172";
  services.v2raya.enable = true;
  systemd.tmpfiles.rules = ["f+ /var/log/v2raya/v2raya.log 660 root root"];
}