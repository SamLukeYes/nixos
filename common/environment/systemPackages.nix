{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    gimp
    gnome.dconf-editor
    shotcut
    tdesktop
    virt-manager
    xournalpp
    zotero

    ((vscode.override {
      commandLineArgs = "--touch-events --enable-wayland-ime --disable-gpu-shader-disk-cache -n";
    }).fhsWithPackages (ps: with ps; [
      nil                               # for nix IDE
      pacman                            # add a dummy makepkg.conf to FHS
      python3Packages.python-lsp-server # for xonsh IDE
    ]))

    # CLI programs
    archix.paru                   # frequently used to query AUR packages
    bat                           # frequently used to view text in terminal
    dig                           # must be available without Internet connection
    file                          # frequently used to view executable type
    jre                           # can always be detected by libreoffice
    nix-output-monitor            # frequently used in nix operations
    pdftk                         # required by Jasminum
    sshfs                         # frequently used for file sharing
    starship                      # configured without nix
    wl-clipboard                  # required by WayDroid

    # themes
    adw-gtk3
    yaru-theme

    # other out-of-tree packages
    yes.ludii
    yes.lx-music-desktop
  ];
}