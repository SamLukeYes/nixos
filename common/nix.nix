{ lib, pkgs, ... }:

let rp = import ../rp.nix; in

{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    package = pkgs.nix;   # avoid using nixUnstable
    settings = {
      auto-optimise-store = true;
      download-attempts = 3;
      experimental-features = [
        "flakes" "nix-command" "repl-flake"
      ];
      fallback = true;
      keep-failed = true;
      keep-outputs = true;
      max-jobs = 3;   # https://github.com/NixOS/nixpkgs/issues/198668
      narinfo-cache-negative-ttl = 300;
      substituters = lib.mkForce [
        "https://mirror.iscas.ac.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://linyinfeng.cachix.org"
        "https://numtide.cachix.org"
        "https://rewine.cachix.org"
        "${rp}https://cache.nixos.org"
        "${rp}https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "rewine.cachix.org-1:aOIg9PvwuSefg59gVXXxGIInHQI9fMpskdyya2xO+7I="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };
  };
}