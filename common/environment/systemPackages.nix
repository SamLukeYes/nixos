{ config,pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    czkawka
    dconf-editor
    tdesktop
    xournalpp

    ((vscode.override {
      commandLineArgs = "--touch-events --enable-wayland-ime --disable-gpu-shader-disk-cache -n";
    }).fhsWithPackages (ps: with ps; [
      libGL                             # required by conda env
      nil                               # for nix IDE
      nodejs                            # for SQLTools SQLite
      pacman                            # add a dummy makepkg.conf to FHS
      python3Packages.python-lsp-server # for xonsh IDE
      xclip                             # for Office Viewer Markdown Editor
    ]
    # https://github.com/NixOS/nixpkgs/issues/356340
    ++ lib.optional config.services.xserver.desktopManager.gnome.enable gnome-shell
  ))

    # CLI programs
    bat                           # frequently used to view text in terminal
    conda                         # manage python env
    dig                           # must be available without Internet connection
    ffmpeg-headless               # video editing
    file                          # frequently used to view executable type
    lsof                          # view port usage
    nix-tree                      # frequently used to inspect space usage
    paru                          # frequently used to query AUR packages
    sqlite                        # to fix nix database in case of corruption
    starship                      # configured without nix
    subversion                    # version control system
    waypipe                       # wayland support for containerized apps
    yt-dlp-light                  # frequently used to download videos

    # out-of-tree packages
    archix.devtools               # required by paru
    yes.mkxp-z                    # required by MadoTAS
  ];
}