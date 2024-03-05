{ config, lib, pkgs, ... }:

{
  programs = {
    adb.enable = true;

    command-not-found.enable = false;

    dconf.enable = true;

    direnv.enable = true;

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

    kdeconnect = {
      enable = true;
      package = lib.mkIf config.services.xserver.desktopManager.gnome.enable
        pkgs.gnomeExtensions.gsconnect;
    };

    nix-index.enable = true;

    wireshark.enable = true;

    xonsh = {
      enable = true;
      package = pkgs.xonsh.override {
        extraPackages = ps: [
          pkgs.yes.xonsh-direnv
        ];
      };
    };

    # requires archix
    pacman = {
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
  };
}
