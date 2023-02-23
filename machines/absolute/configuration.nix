{ pkgs, ... }:

let rp = import ../../rp.nix; in

{
  imports = [
    ./hardware-configuration.nix
    ../../common
    ../../users/yes
  ];

  hardware.bluetooth.powerOnBoot = false;
  networking.hostName = "absolute";
  system.stateVersion = "22.11";

  # TODO: move the following pacman related configurations to a separate flake
  environment = {
    etc = {
      "makepkg.conf".source = "${pkgs.devtools}/share/devtools/makepkg-x86_64.conf";
      "pacman.conf".source = "/old-root/etc/pacman.conf";
      "pacman.d/mirrorlist".text = ''
        Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
        Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch
        Server = ${rp}https://geo.mirror.pkgbuild.com/$repo/os/$arch
      '';
    };
    systemPackages = [ pkgs.paru ];
  };
  
  systemd.services = {
    pacman-init = {
      script = ''
        export KEYRING_IMPORT_DIR=${pkgs.yes.archlinux.archlinux-keyring}/share/pacman/keyrings
        ${pkgs.pacman}/bin/pacman-key --init
        ${pkgs.pacman}/bin/pacman-key --populate archlinux
      '';
      serviceConfig = {
        RemainAfterExit = true;
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
}