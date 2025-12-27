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

    package = pkgs.virtualbox.override {
      javaBindings = false;
    };
  };

  preservation.preserveAt."/persistent" = {
    users.yes = {
      directories = config.users.persistence.directories ++ [
        "git-repos"
        "nix-build"
        "nixos"

        { directory = ".ssh"; mode = "0700"; }
        ".local/state"

        ".local/share/applications"
        ".local/share/backgrounds"
        ".local/share/icons"

        # syncthing
        ".shortcuts"
        "apk"
        "DCIM"
        "Documents"
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
        ".local/share/vscode-sqltools"

        # wireshark
        ".config/wireshark"
      ];

      files = config.users.persistence.files ++ [
        { file = ".config/mimeapps.list"; how = "symlink"; }
        ".config/user-dirs.dirs"
      ];
    };
  };
}
