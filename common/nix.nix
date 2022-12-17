{ config, pkgs, options, lib, ... }:

let rp = import ../rp.nix; in

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "flakes" "nix-command"
      ];
      fallback = true;
      keep-outputs = true;
      max-jobs = 3;   # https://github.com/NixOS/nixpkgs/issues/198668
      substituters = lib.mkForce [
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "${rp}https://cache.nixos.org"
        "${rp}https://linyinfeng.cachix.org"
        "${rp}https://nixos-cn.cachix.org"
        "${rp}https://rewine.cachix.org"
        "${rp}https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
        "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
        "rewine.cachix.org-1:aOIg9PvwuSefg59gVXXxGIInHQI9fMpskdyya2xO+7I="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}