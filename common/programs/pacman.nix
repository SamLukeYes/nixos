{ pkgs, ... }:

{
  programs.pacman = {
    autoSync.enable = true;
    confMode = "0644";
    conf.extraConfig = ''
      [options]
      Color
      ILoveCandy

      [archlinuxcn]
      Server = https://mirrors.bfsu.edu.cn/$repo/$arch
      Server = https://mirror.sjtu.edu.cn/archlinux-cn/$arch
    '';
    keyrings = with pkgs; [
      archlinuxcn-keyring
      archix.archlinux-keyring
    ];
    mirrors = [
      "https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch"
      "https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch"
      "https://geo.mirror.pkgbuild.com/$repo/os/$arch"
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      archix.devtools
      paru
    ];
  };

  preservation.preserveAt."/persistent" = {
    directories = [
      "/var/cache/pacman"
      "/var/log/pacman"
    ];
  };

  users.persistence.directories = [
    ".config/devtools"
    ".config/paru"
  ];
}