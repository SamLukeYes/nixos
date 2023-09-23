{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    gnome.dconf-editor
    gnome-frog
    gnubg
    obs-studio
    shotcut
    tdesktop
    virt-manager
    xournalpp
    zotero

    (makeAutostartItem {
      name = "firefox";
      package = config.programs.firefox.package;
    })

    ((vscode.override {
      commandLineArgs = "--touch-events --enable-wayland-ime -n";
    }).fhsWithPackages (ps: with ps; [
      nil                               # for nix IDE
      pacman                            # add a dummy makepkg.conf to FHS
      python3Packages.python-lsp-server # for xonsh IDE
    ]))

    # CLI programs
    _7zz                          # required by file-roller
    archix.paru                   # frequently used to query AUR packages
    bat                           # frequently used to view text in terminal
    dig                           # must be available without Internet connection
    file                          # frequently used to view executable type
    jre                           # can always be detected by libreoffice
    nix-output-monitor            # frequently used in nix operations
    onedrive                      # required by gnomeExtensions.one-drive-resurrect
    pdftk                         # required by Jasminum
    sshfs                         # frequently used for file sharing
    starship                      # configured without nix
    texlive.combined.scheme-full  # required by Xournal++ and VSCode LateX Workshop
    wl-clipboard                  # required by WayDroid

    # direnv
    direnv
    nix-direnv

    # themes
    adw-gtk3
    yaru-theme

    # Out-of-tree packages
    yes.lx-music-desktop
  ];
}