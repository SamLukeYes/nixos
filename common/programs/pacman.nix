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
      Server = https://repo.archlinuxcn.org/$arch
      CacheServer = https://mirror.sjtu.edu.cn/archlinux-cn/$arch
      CacheServer = https://mirrors.pku.edu.cn/archlinuxcn/$arch
    '';
    keyrings = with pkgs; [
      archlinuxcn-keyring
      archix.archlinux-keyring
    ];
    mirrors = [
      "https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch"
      "https://mirrors.neusoft.edu.cn/archlinux/$repo/os/$arch"
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
      "/var/lib/pacman"
    ];
  };

  users.persistence.directories = [
    ".config/devtools"
    ".config/paru"
  ];
}