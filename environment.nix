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
      bat
      bind
      bookworm
      efibootmgr
      font-manager
      gnomeExtensions.freon
      gnomeExtensions.system-monitor
      gnome.dconf-editor
      gnome.gnome-tweaks
      igv
      intel-gpu-tools
      inxi
      libreoffice
      mkpasswd
      mpv
      papirus-icon-theme
      progress
      starship
      tdesktop
      texlive.combined.scheme-small
      unar
      ventoy-bin
      vscode-fhs
      xorg.xeyes
      xournalpp
      zotero

      (vivaldi.override {
        proprietaryCodecs = true;
        enableWidevine = true;
        commandLineArgs = "--enable-features=VaapiVideoDecoder --use-gl=egl --disable-feature=UseChromeOSDirectVideoDecoder";
      })
    ];
  };
}
