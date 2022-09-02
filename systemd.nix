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
      stuhealth = {
        script = ''
          export DISPLAY=:0
          export XDG_RUNTIME_DIR=/run/user/`id -u`
          ${pkgs.firefox}/bin/firefox https://stuhealth.jnu.edu.cn/
        '';
        serviceConfig.Type = "oneshot";
        startAt = "daily";
      };
    };
  };
}