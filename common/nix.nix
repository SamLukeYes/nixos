{ pkgs, ... }:

{
  nix = {
    channel.enable = false;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 3d";
    };
    package = pkgs.nix;
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      download-attempts = 3;
      experimental-features = [
        "flakes" "nix-command"
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
        "https://nix-community.cachix.org"
        "https://xonsh-xontribs.cachix.org"
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "linyinfeng.cachix.org-1:sPYQXcNrnCf7Vr7T0YmjXz5dMZ7aOKG3EqLja0xr9MM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "xonsh-xontribs.cachix.org-1:LgP0Eb1miAJqjjhDvNafSrzBQ1HEtfNl39kKtgF5LBQ="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };

    # requires flake-utils-plus
    generateNixPathFromInputs = true;
    generateRegistryFromInputs = true;
    linkInputs = true;
  };
}