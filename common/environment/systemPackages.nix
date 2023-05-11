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
    qq
    tdesktop
    virt-manager
    xournalpp
    yaru-theme
    zotero
    
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
    ]))

    # GNOME Shell extensions
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
    starship                      # configured without nix
    texlive.combined.scheme-full  # required by Xournal++ and VSCode LateX Workshop
    wl-clipboard                  # required by WayDroid

    # direnv
    direnv
    nix-direnv

    # Out-of-tree packages
    electron-ncm
    linyinfeng.wemeet
    yes.lx-music-desktop
    yes.snapgene-viewer
  ];
}