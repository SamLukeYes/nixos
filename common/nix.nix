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
      flake-registry = "";
      keep-failed = true;
      keep-outputs = true;
      max-jobs = 2;   # https://github.com/NixOS/nixpkgs/issues/198668
      # max-substitution-jobs = 3;
      narinfo-cache-negative-ttl = 300;
      nix-path = ["nixpkgs=/etc/nix/inputs/nixpkgs"];
      substituters = [
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };

    # requires flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };
}