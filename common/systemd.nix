{ pkgs, ... }:

let
  waitOnline = "${pkgs.networkmanager}/bin/nm-online";
in

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
      ss-ws-local = let
        configDir = "%h/.config/shadowsocks-ws";
      in {
        serviceConfig = {
          ExecStartPre = waitOnline;
          ExecStart = "${pkgs.yes.nodePackages.shadowsocks-ws}/bin/ss-ws-local";
          Restart = "always";
          RestartSec = 5;
          WorkingDirectory = configDir;
        };
        unitConfig = {
          ConditionFileNotEmpty = "${configDir}/config.json";
          StartLimitBurst = 5;
          StartLimitIntervalSec = 60;
        };
        wantedBy = [ "default.target" ];
      };
    };

    tmpfiles.rules = [
      "z /sys/kernel/notes 0400 root root"
    ];

    # https://yhndnzj.com/2022/04/28/systemd-oomd-basic-usage/
    oomd = {
      enableSystemSlice = true;
      enableUserSlices = true;
      extraConfig.DefaultMemoryPressureDurationSec = "10s";
    };

    slices = {
      "-".sliceConfig.ManagedOOMSwap = "kill";
      machine.sliceConfig = {
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "50%";
      };
    };
  };
}