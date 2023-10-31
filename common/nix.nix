{ pkgs, ... }:

{
  nix = {
    channel.enable = false;
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
      max-jobs = 2;   # https://github.com/NixOS/nixpkgs/issues/198668
      # max-substitution-jobs = 3;
      narinfo-cache-negative-ttl = 300;
      nix-path = ["nixpkgs=/etc/nix/inputs/nixpkgs"];
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://rewine.cachix.org"
        "https://xddxdd.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "rewine.cachix.org-1:aOIg9PvwuSefg59gVXXxGIInHQI9fMpskdyya2xO+7I="
        "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };

    # requires flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };
}