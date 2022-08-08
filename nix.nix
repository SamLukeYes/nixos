{ config, pkgs, ... }:

let rp = import ./reverse-proxy.nix; in

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      substituters = [
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "${rp}https://linyinfeng.cachix.org"
      ];
      trusted-public-keys = [
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
      ];
    };
    extraOptions = ''
      keep-outputs = true
    '';
  };
}