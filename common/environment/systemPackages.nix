{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    upscaler

    # CLI programs
    dig  # must be available without Internet connection
    ffmpeg-headless  # exposing the variant used by yt-dlp
    file  # frequently used to view executable type
    nix-tree  # frequently used to inspect space usage
    sqlite  # to fix nix database in case of corruption
    trashy  # trash across filesystems
    waypipe  # wayland support for containerized apps
    yt-dlp  # frequently used to download videos
  ];
}