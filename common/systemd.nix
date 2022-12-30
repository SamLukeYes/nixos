{config, pkgs, ...}:

let rp = import ../rp.nix; in

{
  systemd = {
    nspawn = (builtins.mapAttrs (name: value: {
      filesConfig.Bind = [ "/dev/dri" ];
      networkConfig.Private = false;
    }) {
      old-root = {};
    });
    packages = [ pkgs.onedrive ];
    services = {
      "systemd-nspawn@".serviceConfig.DeviceAllow = [
        "char-drm rwm"
        "/dev/dri rw"
      ];
      aria2b = {
        after = [ "aria2.service" ];
        script = ''
          cd /var/lib/aria2
          ${pkgs.yes.nodePackages.aria2b}/bin/aria2b
        '';
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 5;
        };
        wantedBy = [ "multi-user.target" ];
      };
      pacman-init = {
        script = ''
          export KEYRING_IMPORT_DIR=${pkgs.yes.archlinux.archlinux-keyring}/share/pacman/keyrings
          ${pkgs.pacman}/bin/pacman-key --init
          ${pkgs.pacman}/bin/pacman-key --populate archlinux
        '';
        serviceConfig = {
          Type = "oneshot";
        };
        wantedBy = [ "multi-user.target" ];
      };
      update-pacman-db = {
        requires = [ "network-online.target" ];
        script = ''
          ${pkgs.pacman}/bin/pacman -Sy
          ${pkgs.pacman}/bin/pacman -Fy
        '';
        serviceConfig.Type = "oneshot";
        startAt = "daily";
      };
    };
    user.services = {
      clash.serviceConfig.ExecStart = "${pkgs.clash}/bin/clash";
      clash-subscription = {
        onSuccess = [ "clash.service" ];
        script = ''
          mkdir -p ~/.config/clash
          ${pkgs.curl}/bin/curl -L https://cdn.jsdelivr.net/gh/ssrsub/ssr@master/Clash.yml -o ~/.config/clash/config.yaml
        '';
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 5;
          Type = "oneshot";
        };
        wantedBy = [ "default.target" ];
      };
      nix-index = {
        script = ''
          FILE=index-x86_64-linux
          mkdir -p ~/.cache/nix-index
          cd ~/.cache/nix-index
          ${pkgs.curl}/bin/curl -LO ${rp}https://github.com/Mic92/nix-index-database/releases/latest/download/$FILE
          mv -v $FILE files
        '';
        serviceConfig.Type = "oneshot";
        startAt = "weekly";
      };
      onedrive.wantedBy = [ "default.target" ];
      stuhealth = {
        script = ''
          export DISPLAY=:0
          export XDG_RUNTIME_DIR=/run/user/`id -u`
          ${pkgs.xdg-utils}/bin/xdg-open https://stuhealth.jnu.edu.cn
        '';
        serviceConfig.Type = "oneshot";
        startAt = "daily";
      };
    };
  };
}