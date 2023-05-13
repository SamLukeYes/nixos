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
      policies.DisableAppUpdate = true;
    };

    git.enable = true;

    gnupg.agent.enable = true;

    nix-index.enable = true;

    wireshark.enable = true;

    # requires archix
    pacman = {
      autoSync.enable = true;
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
