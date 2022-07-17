{ config, pkgs, ... }:

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
      randomizedDelaySec = "20min"; # workaround for GDM login
    };
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
      ];
    };
  };
}