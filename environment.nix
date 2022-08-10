{ config, pkgs, ... }:

{
  environment = {

    gnome.excludePackages = with pkgs.gnome; [
      eog  # use gthumb instead
      epiphany  # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator  # use xonsh instead
      gnome-contacts  # not managing contacts on PC
      gnome-font-viewer  # use font-manager instead
      gnome-music  # use gthumb instead
      pkgs.gnome-photos  # use gthumb instead
      simple-scan  # no scanner available
      totem  # use gthumb instead
      evince  # use many other apps for pdf
    ];

    systemPackages = with pkgs; [
      bookworm
      firefox-esr-wayland
      font-manager
      gnome-firmware
      gnome.dconf-editor
      gnome.gnome-tweaks
      gst_all_1.gst-vaapi
      gthumb
      igv
      libreoffice
      papirus-icon-theme
      xournalpp
      zotero

      nur.repos.linyinfeng.clash-for-windows
      nur.repos.linyinfeng.icalingua-plus-plus
      nur.repos.linyinfeng.wemeet
      nur.repos.yes.lx-music-desktop

      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.freon
      gnomeExtensions.improved-osk
      gnomeExtensions.system-monitor
      nur.repos.yes.gnomeExtensions.onedrive

      # CLI programs
      bat   # frequently used in terminal
      pdftk   # required by Jasminum
      starship  # configured in ~/.xonshrc

      # custom packages
      adw-gtk3
      electron-netease-cloud-music

      (python3.withPackages (p: with p; [
        ipykernel openpyxl pandas scipy
      ]))

      (vscode.fhsWithPackages (ps: with ps; [
        nodePackages.pyright
        texlive.combined.scheme-full
      ]))
    ];

    sessionVariables = {
      EDITOR = "nano";
      GST_PLUGIN_PATH_1_0 = ["/run/current-system/sw/lib/gstreamer-1.0"];
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_DBUS_REMOTE = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
