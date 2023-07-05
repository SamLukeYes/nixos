{ pkgs, ... }:

let rp = import ../rp.nix; in

{
  programs = {
    adb.enable = true;

    clash-verge = {
      enable = true;
      autoStart = true;
    };

    command-not-found.enable = false;

    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      package = pkgs.firefox-esr-115;
      policies.DisableAppUpdate = true;
    };

    git.enable = true;

    gnupg.agent.enable = true;

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    nix-index.enable = true;

    wireshark.enable = true;

    # requires archix
    pacman = {
      autoSync.enable = true;
      confMode = "0644";
      conf.extraConfig = ''
        [options]
        Color
        ILoveCandy
      '';
      mirrors = [
        "https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch"
        "https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch"
        "${rp}https://geo.mirror.pkgbuild.com/$repo/os/$arch"
      ];
    };
  };
}
