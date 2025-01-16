{ config,pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    czkawka
    dconf-editor
    tdesktop
    upscaler
    xournalpp

    ((vscode.override {
      commandLineArgs = "--touch-events --enable-wayland-ime --disable-gpu-shader-disk-cache -n";
    }).fhsWithPackages (ps: with ps; [
      libGL                             # required by conda env
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
    nil                           # for VSCode nix IDE
    nix-tree                      # frequently used to inspect space usage
    nodejs                        # for VSCode SQLTools SQLite
    paru                          # frequently used to query AUR packages
    python3Packages.python-lsp-server  # for VSCode xonsh IDE
    sqlite                        # to fix nix database in case of corruption
    starship                      # configured without nix
    subversion                    # version control system
    waypipe                       # wayland support for containerized apps
    wl-clipboard-x11              # for VSCode Office Viewer Markdown Editor
    yt-dlp-light                  # frequently used to download videos

    # out-of-tree packages
    archix.devtools               # required by paru
    yes.mkxp-z                    # required by MadoTAS
  ];
}