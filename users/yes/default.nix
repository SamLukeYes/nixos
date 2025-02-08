{ config, pkgs, ... }:

{
  users = {
    groups.yes.gid = 1000;
    users.yes = {
      description = "Sam L. Yes";
      group = "yes";
      extraGroups = [
        "adbusers"
        "networkmanager"
        "wheel"
        "wireshark"
        "vboxusers"
      ];
      initialHashedPassword = "";
      isNormalUser = true;
      uid = 1000;
    };
  };

  networking.proxy.default = "http://127.0.0.1:7890";

  programs = {
    adb.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  services = {
    mihomo = {
      enable = true;
      configFile = "${config.users.users.yes.home}/Private/proxies/Clash.yaml";
      webui = pkgs.metacubexd;
    };

    syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = "yes";
      dataDir = config.users.users.yes.home;
    };
  };

  systemd.services.mihomo.serviceConfig = {
    Restart = "on-failure";
    RestartStep = 5;
    RestartMaxDelaySec = "1min";
  };

  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;

    # Toggle kvm support in case virtualbox doesn't build
    enableKvm = true;
    addNetworkInterface = false;
  };
}
