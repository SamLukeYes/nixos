{...}: rec {
    nixos-cn.url = "git+${import ./rp.nix}https://github.com/nixos-cn/flakes";
    nixos-hardware.url = "git+${import ./rp.nix}https://github.com/NixOS/nixos-hardware";
    rewine.url = "git+${import ./rp.nix}https://github.com/wineee/nur-packages";
    xddxdd.url = "git+${import ./rp.nix}https://github.com/xddxdd/nur-packages";

    # nixpkgs
    nixos-unstable.url = "git+${import ./rp.nix}https://github.com/NixOS/nixpkgs?ref=nixos-unstable";
    pr-pano.url = "git+${import ./rp.nix}https://github.com/michojel/nixpkgs?ref=gnome-shell-extension-pano";
    nixpkgs = nixos-unstable;
}