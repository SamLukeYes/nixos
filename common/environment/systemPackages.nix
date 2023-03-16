{ pkgs, ... }:

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
    libreoffice
    obs-studio
    olex2
    tdesktop
    virt-manager
    xournalpp
    yaru-theme
    zotero

    linyinfeng.wemeet
    rewine.electron-netease-cloud-music
    yes.lx-music-desktop
    yes.qq-appimage
    yes.snapgene-viewer

    gnomeExtensions.appindicator
    gnomeExtensions.customize-ibus
    gnomeExtensions.freon
    gnomeExtensions.one-drive-resurrect
    gnomeExtensions.pano
    gnomeExtensions.section-todo-list

    # CLI programs
    bat                           # frequently used in terminal
    dig                           # must be available without Internet connection
    nix-output-monitor            # frequently used in nix operations
    onedrive                      # required by gnomeExtensions.one-drive-resurrect
    pdftk                         # required by Jasminum
    starship                      # configured in ~/.xonshrc

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