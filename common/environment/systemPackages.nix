{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    adw-gtk3
    authenticator
    celluloid
    gnome-firmware
    gnome-frog
    gnome.dconf-editor
    gnome.gnome-sound-recorder
    gnome.gnome-tweaks
    gnome.nautilus-python
    libreoffice-fresh
    obs-studio
    tdesktop
    virt-manager
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
    gnomeExtensions.pano
    gnomeExtensions.section-todo-list

    # CLI programs
    bat                           # frequently used in terminal
    dig                           # must be available without Internet connection
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

    (ventoy-bin.override {
      defaultGuiType = "gtk3";
      withGtk3 = true;
    })

    ((vscode.override {
      commandLineArgs = "--touch-events -n";
    }).fhsWithPackages (ps: with ps; [
      config.programs.firefox.package   # for markdown export
      nil                               # for nix IDE
      pacman                            # add a dummy makepkg.conf to FHS
      python3Packages.python-lsp-server # for xonsh IDE
      texlive.combined.scheme-full      # for latex workshop
    ]))
  ];
}