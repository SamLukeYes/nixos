{ pkgs, ... }:

{
  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/desktop-managers/plasma5.nix
    plasma5.excludePackages = with pkgs.libsForQt5; [
      elisa                 # use haruna instead
    ];

    sessionVariables.NIXOS_OZONE_WL = "1";

    systemPackages = with pkgs; with libsForQt5; [
      discover
      filelight
      haruna
      kwalletmanager
      ksystemlog
      libreoffice-qt
      maliit-keyboard
      partition-manager

      # CLI programs required by Plasma
      linuxquota
      pciutils
    ];
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
    ];
  };

  programs.ssh.startAgent = true;

  # security.pam.services.sddm.enableGnomeKeyring = true;

  services = {
    # cpupower-gui.enable = false;
    xserver = {
      desktopManager.plasma5.enable = true;
      displayManager.sddm = {
        enable = true;
        # settings = {
        #   General.DisplayServer = "wayland";
        #   Wayland.CompositorCommand = "kwin_wayland";
        # };
      };
    };
  };
}