{ pkgs, ... }:

{
  imports = [
    ./java
    ./quickemu.nix
  ];
  
  environment.systemPackages = with pkgs; [
    gnome-frog
    zotero

    ((vscode.override {
      commandLineArgs = "--touch-events --enable-wayland-ime --disable-gpu-shader-disk-cache -n";
    }).fhsWithPackages (ps: with ps; [
      libGL                             # required by conda env
      nil                               # for nix IDE
      pacman                            # add a dummy makepkg.conf to FHS
      python3Packages.python-lsp-server # for xonsh IDE
      sqlite                            # allow connection to sqlite database
      xclip                             # for Office Viewer Markdown Editor
    ]))
    
    # large optional dependencies of GUI applications
    texlive.combined.scheme-full
  ];
}