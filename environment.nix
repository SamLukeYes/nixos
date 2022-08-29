{ config, pkgs, ... }:

let
  my-python = pkgs.python3.withPackages (p: with p; [
    ipykernel openpyxl statsmodels
  ]);
in

{
  environment = {

    etc = {
      "makepkg.conf".source = "${pkgs.nur.repos.yes.archlinux.devtools}/share/devtools/makepkg-x86_64.conf";
      "pacman.conf".source = "${pkgs.nur.repos.yes.archlinux.devtools}/share/devtools/pacman-extra.conf";
      "pacman.d/gnupg".source = "${pkgs.nur.repos.yes.archlinux.pacman-gnupg}/etc/pacman.d/gnupg";
      "pacman.d/mirrorlist".text = ''
        Server = https://mirrors.bfsu.edu.cn/archlinux/$repo/os/$arch
        Server = https://m.mirrorz.org/archlinux/$repo/os/$arch
        Server = https://mirror.sjtu.edu.cn/archlinux/$repo/os/$arch
      '';
    };

    gnome.excludePackages = with pkgs.gnome; [
      eog  # use gthumb instead
      epiphany  # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator  # use xonsh instead
      gnome-contacts  # not managing contacts on PC
      gnome-music  # use gthumb instead
      pkgs.gnome-photos  # use gthumb instead
      gnome-weather  # ugly as hell
      simple-scan  # no scanner available
      totem  # use gthumb instead
      evince  # use many other apps for pdf
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
      papirus-icon-theme
      ppsspp-sdl-wayland
      xournalpp
      zotero

      nur.repos.linyinfeng.clash-for-windows
      nur.repos.linyinfeng.icalingua-plus-plus
      nur.repos.linyinfeng.wemeet
      nur.repos.shadowrz.adw-gtk3
      nur.repos.yes.lx-music-desktop
      nur.repos.yes.ppet

      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.freon
      gnomeExtensions.improved-osk
      gnomeExtensions.system-monitor
      nur.repos.yes.gnomeExtensions.onedrive

      # CLI programs
      bat   # frequently used in terminal
      dig   # must be available without Internet connection
      pdftk   # required by Jasminum
      starship  # configured in ~/.xonshrc

      # custom packages
      electron-netease-cloud-music

      (vscode.fhsWithPackages (ps: with ps; [
        nodePackages.pyright
        texlive.combined.scheme-full
        my-python
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
