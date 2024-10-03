{ pkgs, ... }:

{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    package = pkgs.lix;
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
      max-substitution-jobs = 5;
      narinfo-cache-negative-ttl = 300;
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://linyinfeng.cachix.org"
        "https://rewine.cachix.org"
        "https://xonsh-xontribs.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
        "rewine.cachix.org-1:aOIg9PvwuSefg59gVXXxGIInHQI9fMpskdyya2xO+7I="
        "xonsh-xontribs.cachix.org-1:LgP0Eb1miAJqjjhDvNafSrzBQ1HEtfNl39kKtgF5LBQ="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      trusted-users = [ "root" "@wheel" ];
    };

    # requires flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };
}