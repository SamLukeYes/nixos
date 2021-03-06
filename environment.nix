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
      gnome-music  # use mpv instead
      pkgs.gnome-photos  # use gthumb instead
      simple-scan  # no scanner available
      totem  # use mpv instead
      evince  # use many other apps for pdf
    ];

    systemPackages = with pkgs; [
      adw-gtk3
      bat
      bookworm
      efibootmgr
      firefox-esr-wayland
      font-manager
      gnomeExtensions.freon
      gnomeExtensions.system-monitor
      gnome.dconf-editor
      gnome.gnome-tweaks
      gthumb
      igv
      libreoffice
      mpv
      papirus-icon-theme
      starship
      vscode-fhs
      xournalpp
      zotero

      nur.repos.linyinfeng.clash-for-windows
      nur.repos.linyinfeng.icalingua-plus-plus
      nur.repos.linyinfeng.wemeet
      nur.repos.yes.gnomeExtensions.onedrive
      nur.repos.yes.lx-music-desktop
    ];

    sessionVariables = {
      EDITOR = "nano";
      MOZ_DBUS_REMOTE = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
