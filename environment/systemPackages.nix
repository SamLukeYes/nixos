{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    firefox
    gnome-firmware
    gnome.dconf-editor
    gnome.gnome-sound-recorder
    gnome.gnome-tweaks
    gnome.nautilus-python
    gthumb
    igv
    libreoffice
    obs-studio
    ppsspp-sdl-wayland
    xournalpp
    yaru-theme
    zotero

    nur.repos.linyinfeng.icalingua-plus-plus
    nur.repos.linyinfeng.wemeet
    nur.repos.xddxdd.wechat-uos
    nur.repos.yes.lx-music-desktop
    nur.repos.yes.ppet
    nur.repos.yes.pypvz

    gnomeExtensions.appindicator
    gnomeExtensions.customize-ibus
    gnomeExtensions.freon
    gnomeExtensions.improved-osk
    nur.repos.yes.gnomeExtensions.onedrive
    pano

    # CLI programs
    bat                           # frequently used in terminal
    dig                           # must be available without Internet connection
    pdftk                         # required by Jasminum
    starship                      # configured in ~/.xonshrc
    nur.repos.yes.archlinux.paru  # takes too long to build

    # custom packages
    electron-netease-cloud-music

    ((vscode.override {
      commandLineArgs = "--touch-events -n";
    }).fhsWithPackages (ps: with ps; [
      my-python                     # allow updating python env without reboot
      nodePackages.pyright          # for pylance
      pacman                        # add a dummy makepkg.conf to FHS
      texlive.combined.scheme-full  # for latex workshop
    ]))
  ];
}