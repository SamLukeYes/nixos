{ config, pkgs, ... }:

{
  environment = {

    gnome.excludePackages = with pkgs.gnome; [
      epiphany  # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator  # use xonsh instead
      gnome-contacts  # not managing contacts on PC
      gnome-font-viewer  # use font-manager instead
      gnome-music  # use mpv instead
      simple-scan  # no scanner available
      totem  # use mpv instead
      evince  # use firefox for email
      geary  # use firefox for email
    ];

    systemPackages = with pkgs; [
      bat
      bookworm
      efibootmgr
      electron
      firefox-esr-wayland
      font-manager
      gnomeExtensions.freon
      gnomeExtensions.system-monitor
      gnome.dconf-editor
      gnome.gnome-tweaks
      igv
      libreoffice
      mpv
      onedrive
      papirus-icon-theme
      starship
      tdesktop
      vscode-fhs
      xorg.xeyes
      xournalpp
      zotero

      nur.repos.linyinfeng.icalingua-plus-plus
      nur.repos.linyinfeng.wemeet

      # custom packages
      lx-music-desktop
    ];

    sessionVariables = {
      MOZ_DBUS_REMOTE = "1";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };
}
