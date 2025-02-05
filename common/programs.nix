{ config, lib, pkgs, ... }:

{
  programs = {
    command-not-found.enable = false;

    dconf.enable = true;

    direnv.enable = true;

    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
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

    xonsh = {
      enable = true;

      config = ''
        $LANG = "zh_CN.UTF-8"

        if __xonsh__.env.get("WAYLAND_DISPLAY"):
            $GTK_IM_MODULE = ""
            $QT_IM_MODULE = ""

        # TODO: this shouldn't be necessary
        $SHELL_TYPE = "best"
      '';

      extraPackages = ps: with ps; [
        distro
        xonsh.xontribs.xonsh-direnv
      ];
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

    # requires nix-index-database
    nix-index-database.comma.enable = true;
  };
}
