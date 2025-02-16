{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    upscaler

    # CLI programs
    bat  # frequently used to view text in terminal
    dig  # must be available without Internet connection
    ffmpeg-headless  # video editing
    file  # frequently used to view executable type
    nil  # for VSCode nix IDE
    nix-tree  # frequently used to inspect space usage
    python3Packages.python-lsp-server  # for VSCode xonsh IDE
    sqlite  # to fix nix database in case of corruption
    starship  # configured without nix
    trashy  # trash across filesystems
    waypipe  # wayland support for containerized apps
    wl-clipboard-x11  # for VSCode Office Viewer Markdown Editor
    yt-dlp-light  # frequently used to download videos
  ];
}