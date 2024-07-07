{ pkgs, ... }:

# let
#   waitOnline = "${pkgs.networkmanager}/bin/nm-online";
# in

{
  systemd = {
    services.cpupower-gui.enable = false;

    user.services = {
      cpupower-gui.enable = false;
      sslocal = let
        configFile = "%h/.config/shadowsocks/config.json";
      in {
        serviceConfig = {
          ExecStart = "${pkgs.shadowsocks-rust}/bin/sslocal -c ${configFile}";
          Restart = "on-failure";
        };
        unitConfig.ConditionFileNotEmpty = configFile;
        wantedBy = [ "default.target" ];
      };
    };

    tmpfiles.rules = [
      "z /sys/kernel/notes 0400 root root"
    ];
  };
}