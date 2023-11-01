{ lib, pkgs, ... }:

{
  programs = {
    adb.enable = true;

    clash-verge = {
      enable = lib.mkDefault true;
      autoStart = true;
    };

    command-not-found.enable = false;

    dconf.enable = true;

    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      package = pkgs.firefox-esr-115;
      policies.DisableAppUpdate = true;
    };

    git.enable = true;

    gnupg.agent = {
      enable = true;
      # pinentryFlavor = "gnome3";
    };

    kdeconnect.enable = true;

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

        [archlinuxcn]
        Server = https://mirror.sjtu.edu.cn/archlinux-cn/$arch
        Server = https://mirrors.bfsu.edu.cn/$repo/$arch
      '';
      keyrings = with pkgs; [
        archlinuxcn-keyring
        archix.archlinux-keyring
      ];
      mirrors = [
        "https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch"
        "https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch"
      ];
    };
  };
}
