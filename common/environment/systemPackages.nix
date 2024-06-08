{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    gnome.dconf-editor
    pot
    tdesktop
    xournalpp
    zotero

    # CLI programs
    bat                           # frequently used to view text in terminal
    conda                         # manage python env
    dig                           # must be available without Internet connection
    ffmpeg                        # video editing
    file                          # frequently used to view executable type
    lsof                          # view port usage
    nix-tree                      # frequently used to inspect space usage
    paru                          # frequently used to query AUR packages
    sshfs                         # frequently used for file sharing
    starship                      # configured without nix
    subversion                    # version control system
    yt-dlp-light                  # frequently used to download videos

    # other out-of-tree packages
    yes.iptux
  ];
}