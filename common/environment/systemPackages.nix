{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    tdesktop
    upscaler

    # CLI programs
    bat                           # frequently used to view text in terminal
    dig                           # must be available without Internet connection
    ffmpeg-headless               # video editing
    file                          # frequently used to view executable type
    lsof                          # view port usage
    nil                           # for VSCode nix IDE
    nix-tree                      # frequently used to inspect space usage
    paru                          # frequently used to query AUR packages
    python3Packages.python-lsp-server  # for VSCode xonsh IDE
    sqlite                        # to fix nix database in case of corruption
    starship                      # configured without nix
    waypipe                       # wayland support for containerized apps
    wl-clipboard-x11              # for VSCode Office Viewer Markdown Editor
    yt-dlp-light                  # frequently used to download videos

    # out-of-tree packages
    archix.devtools               # required by paru
  ];
}