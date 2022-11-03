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
      keep-outputs = true;
      max-jobs = 3;   # https://github.com/NixOS/nixpkgs/issues/198668
      substituters = lib.mkForce [
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "${rp}https://cache.nixos.org"
        "${rp}https://nix-community.cachix.org"
        "${rp}https://nixos-cn.cachix.org"
        "${rp}https://linyinfeng.cachix.org"
        "${rp}https://rewine.cachix.org"
        "${rp}https://xddxdd.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
        "rewine.cachix.org-1:aOIg9PvwuSefg59gVXXxGIInHQI9fMpskdyya2xO+7I="
        "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="
      ];
    };
  };
}