{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    gnome.dconf-editor
    pot
    shotcut
    tdesktop
    xournalpp
    zotero

    # CLI programs
    bat                           # frequently used to view text in terminal
    conda                         # manage python env
    dig                           # must be available without Internet connection
    file                          # frequently used to view executable type
    lsof                          # view port usage
    nix-tree                      # frequently used to inspect space usage
    paru                          # frequently used to query AUR packages
    sshfs                         # frequently used for file sharing
    starship                      # configured without nix
    subversion                    # version control system

    # other out-of-tree packages
    yes.iptux
  ];
}