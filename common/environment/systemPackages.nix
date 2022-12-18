{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    adw-gtk3
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
    tdesktop
    xournalpp
    yaru-theme
    zotero

    linyinfeng.icalingua-plus-plus
    linyinfeng.wemeet
    rewine.electron-netease-cloud-music
    yes.electronic-wechat
    yes.lx-music-desktop
    yes.ppet

    gnomeExtensions.appindicator
    gnomeExtensions.customize-ibus
    gnomeExtensions.freon
    gnomeExtensions.one-drive-resurrect
    pano

    # CLI programs
    bat                           # frequently used in terminal
    dig                           # must be available without Internet connection
    nix-index                     # frequently used in terminal
    onedrive                      # required by gnomeExtensions.one-drive-resurrect
    pdftk                         # required by Jasminum
    starship                      # configured in ~/.xonshrc
    yes.archlinux.paru            # takes too long to build

    (makeDesktopItem {
      desktopName = "yacd";
      name = "yacd";
      exec = "${electron}/bin/electron ${linyinfeng.yacd}/index.html";
      icon = "${linyinfeng.yacd}/yacd-128.png";
    })

    ((vscode.override {
      commandLineArgs = "--touch-events -n";
    }).fhsWithPackages (ps: with ps; [
      nil                               # for nix IDE
      pacman                            # add a dummy makepkg.conf to FHS
      python3Packages.python-lsp-server # for xonsh IDE
      texlive.combined.scheme-full      # for latex workshop
    ]))
  ];
}