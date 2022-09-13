{ config, pkgs, options, lib, ... }:

let rp = import ./reverse-proxy.nix; in

{
  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
      ];
      keep-outputs = true;
      substituters = lib.mkForce [
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "${rp}https://cache.nixos.org"
        "${rp}https://nix-community.cachix.org"
        "${rp}https://nixos-cn.cachix.org"
        "${rp}https://internetunexplorer.cachix.org"
        "${rp}https://linyinfeng.cachix.org"
        "${rp}https://rewine.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nixos-cn.cachix.org-1:L0jEaL6w7kwQOPlLoCR3ADx+E3Q8SEFEcB9Jaibl0Xg="
        "internetunexplorer.cachix.org-1:F6CYMkx5/TJmDQQ+DTsFzRy58Ad+doYEW5CdVDZJVdY="
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
        "rewine.cachix.org-1:aOIg9PvwuSefg59gVXXxGIInHQI9fMpskdyya2xO+7I="
      ];
    };
  };
}