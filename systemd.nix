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
          content=`${pkgs.curl}/bin/curl -L https://stuhealth.jnu.edu.cn | ${pkgs.gnugrep}/bin/grep verifyID`
          verifyID=`echo $content | ${pkgs.python3}/bin/python -c "print(input().split('%3D')[-1].split('&')[0])"`
          ${pkgs.firefox}/bin/firefox https://weixinfwh.jnu.edu.cn/wechat_auth/wechat/wechatClientAsync?verifyID=$verifyID
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