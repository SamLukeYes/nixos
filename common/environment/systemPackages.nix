{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    adw-gtk3
    adwaita-qt6
    authenticator
    celluloid
    firefox
    gnome-firmware
    gnome.dconf-editor
    gnome.gnome-sound-recorder
    gnome.gnome-tweaks
    gnome.nautilus-python
    igv
    libreoffice-fresh
    obs-studio
    ppsspp-sdl-wayland
    qgnomeplatform-qt6
    tdesktop
    xournalpp
    yaru-theme
    zotero

    nixos-cn.re-export.icalingua-plus-plus
    nixos-cn.re-export.wemeet-linyinfeng
    rewine.electron-netease-cloud-music
    yes.electronic-wechat
    yes.lx-music-desktop
    yes.ppet
    yes.pypvz

    gnomeExtensions.appindicator
    gnomeExtensions.customize-ibus
    gnomeExtensions.freon
    pano
    yes.gnomeExtensions.onedrive

    # CLI programs
    bat                           # frequently used in terminal
    dig                           # must be available without Internet connection
    pdftk                         # required by Jasminum
    starship                      # configured in ~/.xonshrc
    yes.archlinux.paru            # takes too long to build

    (makeDesktopItem {
      desktopName = "yacd";
      name = "yacd";
      exec = "${electron}/bin/electron ${nixos-cn.re-export.yacd-linyinfeng}/index.html";
      icon = "${nixos-cn.re-export.yacd-linyinfeng}/yacd-128.png";
    })

    ((vscode.override {
      commandLineArgs = "--touch-events -n";
    }).fhsWithPackages (ps: with ps; [
      nil                           # nix language server for nix IDE
      nodePackages.pyright          # for pylance
      pacman                        # add a dummy makepkg.conf to FHS
      texlive.combined.scheme-full  # for latex workshop
    ]))
  ];
}