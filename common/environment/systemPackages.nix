{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    adw-gtk3
    authenticator
    celluloid
    gnome-frog
    gnome.dconf-editor
    gnome.gnome-sound-recorder
    gnome.gnome-tweaks
    gnome.nautilus-python
    libreoffice
    obs-studio
    tdesktop
    virt-manager
    xournalpp
    yaru-theme
    zotero

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
    archix.paru                   # frequently used to query AUR packages
    bat                           # frequently used to view text in terminal
    dig                           # must be available without Internet connection
    file                          # frequently used to view executable type
    libreoffice.unwrapped.jdk     # can always be detected by libreoffice
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
    yes.lx-music-desktop
  ];
}