# { pkgs, ... }:

{
  services.flatpak.enable = true;

  # https://github.com/NixOS/nixpkgs/issues/119433#issuecomment-1326957279
  # fonts.fontDir.enable = true;
  # system.fsPackages = [ pkgs.bindfs ];
  # fileSystems = let
  #   mkRoSymBind = path: {
  #     device = path;
  #     fsType = "fuse.bindfs";
  #     noCheck = true;
  #     options = [ "ro" "resolve-symlinks" "x-gvfs-hide" "x-systemd.automount" ];
  #   };
  # in {
  #   # Create an FHS mount to support flatpak host icons/fonts
  #   # Should remove after https://github.com/flatpak/flatpak/issues/4692 is fixed
  #   "/usr/share/icons" = mkRoSymBind "/run/current-system/sw/share/icons";
  #   "/usr/share/fonts" = mkRoSymBind "/run/current-system/sw/share/X11/fonts";
  # };
}