{config, pkgs, ...}:

let rp = import ../rp.nix; in

{
  systemd = {
    nspawn = (builtins.mapAttrs (name: value: {
      networkConfig.Private = false;
    }) {
      deepin20 = {};
      old-root = {};
    });
    services.update-pacman-db = {
      requires = [ "network-online.target" ];
      script = ''
        ${pkgs.pacman}/bin/pacman -Sy
        ${pkgs.pacman}/bin/pacman -Fy
      '';
      serviceConfig.Type = "oneshot";
      startAt = "daily";
    };
    user.services = {
      clash.serviceConfig.ExecStart = "${pkgs.clash}/bin/clash";
      clash-subscription = {
        onSuccess = [ "clash.service" ];
        script = ''
          mkdir -p ~/.config/clash
          ${pkgs.curl}/bin/curl -L https://openit.daycat.space/clash -o ~/.config/clash/config.yaml
        '';
        serviceConfig = {
          Restart = "on-failure";
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
      stuhealth = {
        script = ''
          export DISPLAY=:0
          export XDG_RUNTIME_DIR=/run/user/`id -u`
          ${pkgs.xdg-utils}/bin/xdg-open https://stuhealth.jnu.edu.cn
        '';
        serviceConfig.Type = "oneshot";
        startAt = "daily";
      };
      yacd = {
        script = ''
          cd ${pkgs.nixos-cn.re-export.yacd-linyinfeng}
          ${pkgs.python3}/bin/python -m http.server 8080
        '';
        serviceConfig.Restart = "always";
        wantedBy = [ "default.target" ];
      };
    };
  };
}