{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    dconf-editor
    godot_4
    pixelorama
    pot
    tdesktop
    wineWow64Packages.stagingFull
    xournalpp
    zotero

    # CLI programs
    bat                           # frequently used to view text in terminal
    conda                         # manage python env
    dig                           # must be available without Internet connection
    ffmpeg-headless               # video editing
    file                          # frequently used to view executable type
    gamescope                     # force resize window
    lsof                          # view port usage
    nix-tree                      # frequently used to inspect space usage
    paru                          # frequently used to query AUR packages
    starship                      # configured without nix
    subversion                    # version control system
    yt-dlp-light                  # frequently used to download videos

    # other out-of-tree packages
    yes.mkxp-z
  ];
}