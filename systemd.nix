{config, pkgs, ...}:

{
  systemd = {
    nspawn.old-root = {
      networkConfig.Private = false;
    };
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
      clash = {
        after = [ "clash-subscription.service" ];
        serviceConfig.ExecStart = "${pkgs.clash}/bin/clash";
        wantedBy = [ "default.target" ];
      };
      clash-subscription = {
        script = ''
          ${pkgs.curl}/bin/curl -L https://openit.daycat.space/clash -o ~/.config/clash/config.yaml
        '';
        serviceConfig.Type = "oneshot";
        wantedBy = [ "default.target" ];
      };
      stuhealth = {
        script = ''
          export DISPLAY=:0
          export XDG_RUNTIME_DIR=/run/user/`id -u`
          ${pkgs.nur.repos.yes.jnu-open}/bin/jnu-open https://stuhealth.jnu.edu.cn
        '';
        serviceConfig.Type = "oneshot";
        startAt = "daily";
      };
      yacd = {
        script = ''
          cd ${pkgs.nur.repos.linyinfeng.yacd}
          ${pkgs.my-python}/bin/python -m http.server 8080
        '';
        serviceConfig.restart = "always";
        wantedBy = [ "default.target" ];
      };
    };
  };
}