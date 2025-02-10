{ config, lib, pkgs, ... }:

let
  gid = 1000;
  uid = 1000;
in

{
  users = {
    groups.yes = {
      inherit gid;
    };
    users.yes = {
      inherit uid;
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
    };
  };

  networking.proxy.default = lib.mkIf config.services.mihomo.enable
    "http://127.0.0.1:7890";

  programs = {
    adb.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  services = {
    mihomo = {
      enable = lib.mkDefault true;
      configFile =
        "${config.users.users.yes.home}/Private/proxies/Clash.yaml";
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

  # impermanence
  environment.persistence."/persistent" = {
    # hideMounts = true;
    users.yes = {
      directories = config.users.persistence.directories ++ [
        "bin"
        "git-repos"
        "nix-build"
        "nixos"

        ".local/share"
        ".local/state"
        { directory = ".ssh"; mode = "0700"; }

        # adb
        ".android"

        # syncthing
        ".config/syncthing"
        "apk"
        "DCIM"
        "Documents"
        "KernelFlasher"
        "Music"
        "Pictures"
        "PopCap Games"
        "Private"
        "Public"
        "Sync"
        "Videos"

        # virtualbox
        "VirtualBox VMs"
        ".config/VirtualBox"

        # vscode extensions
        ".continue"
        ".m2"
        ".vscode"  # I only see extensions here

        # wireshark
        ".config/wireshark"
      ];

      files = config.users.persistence.files ++ [
        ".config/user-dirs.dirs"
      ];
    };
  };

  fileSystems."/home/yes" = {
    fsType = "tmpfs";
    neededForBoot = true;  # required, or persistent files won't show up
    options = [
      "mode=700"
      "gid=${toString gid}"
      "uid=${toString uid}"
    ];
  };
}
