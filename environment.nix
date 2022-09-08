{ config, pkgs, ... }:

let
  my-python = pkgs.python3.withPackages (p: with p; [
    ipykernel openpyxl statsmodels
  ]);
  rp = import ./reverse-proxy.nix;
in

{
  environment = {

    etc = {
      "makepkg.conf".source = "${pkgs.nur.repos.yes.archlinux.devtools}/share/devtools/makepkg-x86_64.conf";
      "pacman.conf".source = "/old-root/etc/pacman.conf";
      "pacman.d/gnupg".source = "${pkgs.nur.repos.yes.archlinux.pacman-gnupg}/etc/pacman.d/gnupg";
      "pacman.d/mirrorlist".text = ''
        Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
        Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch
        Server = ${rp}https://geo.mirror.pkgbuild.com/$repo/os/$arch
      '';
    };

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome.excludePackages = with pkgs.gnome; [
      eog                     # use gthumb instead
      epiphany                # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator        # use xonsh instead
      gnome-contacts          # not managing contacts on PC
      gnome-music             # use gthumb instead
      pkgs.gnome-photos       # use gthumb instead
      gnome-weather           # ugly as hell
      simple-scan             # no scanner available
      totem                   # use gthumb instead
      evince                  # use many other apps for pdf
      geary                   # use web browser instead
    ];

    systemPackages = with pkgs; [
      bookworm
      firefox
      gnome-firmware
      gnome.dconf-editor
      gnome.gnome-tweaks
      gnome.nautilus-python
      gthumb
      igv
      libreoffice
      obs-studio
      papirus-icon-theme
      ppsspp-sdl-wayland
      xournalpp
      zotero

      nur.repos.linyinfeng.clash-for-windows
      nur.repos.linyinfeng.icalingua-plus-plus
      nur.repos.linyinfeng.wemeet
      nur.repos.yes.lx-music-desktop
      nur.repos.yes.ppet

      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.freon
      gnomeExtensions.improved-osk
      gnomeExtensions.system-monitor
      nur.repos.yes.gnomeExtensions.onedrive

      # CLI programs
      bat                           # frequently used in terminal
      dig                           # must be available without Internet connection
      pdftk                         # required by Jasminum
      starship                      # configured in ~/.xonshrc
      nur.repos.yes.archlinux.paru  # takes too long to build

      # custom packages
      adw-gtk3
      electron-netease-cloud-music

      (vscode.fhsWithPackages (ps: with ps; [
        my-python                     # allow modify python env without reboot
        nodePackages.pyright          # for pylance
        pacman                        # add a dummy makepkg.conf to FHS
        texlive.combined.scheme-full  # for latex workshop
      ]))
    ];

    sessionVariables = {
      EDITOR = "nano";
      GST_PLUGIN_PATH_1_0 = ["${pkgs.gst_all_1.gst-vaapi}/lib/gstreamer-1.0"];
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_DBUS_REMOTE = "1";
      MOZ_USE_XINPUT2 = "1";
      PYTHONPATH = ["${my-python}/${my-python.sitePackages}"];
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
