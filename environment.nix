{ config, pkgs, ... }:

{
  environment = {

    gnome.excludePackages = with pkgs.gnome; [
      epiphany  # use vivaldi instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator  # use xonsh instead
      gnome-font-viewer  # use font-manager instead
      gnome-music  # use mpv instead
      simple-scan  # no scanner available
      totem  # use mpv instead
      evince  # use vivaldi instead
      geary  # use vivaldi instead
    ];

    systemPackages = with pkgs; [
      bind
      bookworm
      dconf-editor
      efibootmgr
      font-manager
      gnome.gnome-tweaks
      igv
      intel-gpu-tools
      inxi
      libreoffice
      mkpasswd
      mpv
      papirus-icon-theme
      progress
      tdesktop
      texlive.combined.scheme-small
      unar
      ventoy-bin
      vivaldi
      vscode-fhs
      xorg.xeyes
      xournalpp
      zotero
    ];
  };
}