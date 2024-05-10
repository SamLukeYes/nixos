{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    authenticator
    charles
    gnome.dconf-editor
    pot
    rustdesk-flutter
    shotcut
    tdesktop
    xmind
    xournalpp
    zotero

    seafile-client
    (makeAutostartItem {
      name = "seafile";
      package = seafile-client;
    })

    ((vscode.override {
      commandLineArgs = "--touch-events --enable-wayland-ime --disable-gpu-shader-disk-cache -n";
    }).fhsWithPackages (ps: with ps; [
      nil                               # for nix IDE
      pacman                            # add a dummy makepkg.conf to FHS
      python3Packages.python-lsp-server # for xonsh IDE
      sqlite                            # allow connection to sqlite database
      xclip                             # for Office Viewer Markdown Editor
    ]))

    # CLI programs
    bat                           # frequently used to view text in terminal
    conda                         # manage python env
    dig                           # must be available without Internet connection
    file                          # frequently used to view executable type
    paru                          # frequently used to query AUR packages
    pdftk                         # required by Jasminum
    sshfs                         # frequently used for file sharing
    starship                      # configured without nix
    subversion                    # version control system

    # other out-of-tree packages
    yes.iptux
    yes.ludii
  ];
}