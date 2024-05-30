{ lib, pkgs, ... }:

{
  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome.excludePackages = with pkgs.gnome; [
      gnome-shell-extensions  # use the standalone versions of these extensions
      epiphany                # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator        # use xonsh instead
      pkgs.gnome-console      # use blackbox-terminal instead
      gnome-contacts          # useless without syncing with google services
      gnome-maps              # use online maps instead
      gnome-music             # use celluloid instead
      simple-scan             # no scanner available
      totem                   # use celluloid instead
      evince                  # use web browser for pdf
      geary                   # use web browser instead
    ];

    variables = {
      # Allow apps to detect gstreamer plugins
      GST_PLUGIN_PATH_1_0 = lib.makeSearchPath "lib/gstreamer-1.0" (
        with pkgs.gst_all_1; [
          gst-plugins-bad
          gst-plugins-good
          gst-plugins-ugly
          gst-vaapi
        ]
      );

      QT_WAYLAND_DECORATION = "adwaita";
    };

    systemPackages = with pkgs; [
      blackbox-terminal
      celluloid
      endeavour
      gimp
      gnome.gnome-sound-recorder
      gnome.gnome-tweaks
      gnome-firmware
      libreoffice

      # nautilus extensions
      gnome.nautilus-python
      nautilus-open-in-blackbox

      # GNOME Shell extensions
      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.freon
      gnomeExtensions.places-status-indicator
      gnomeExtensions.system-monitor
      gnomeExtensions.task-widget

      # Qt plugins
      qadwaitadecorations
      qadwaitadecorations-qt6
      qt6.qtwayland

      # CLI programs required by file-roller
      _7zz
      binutils

      # themes
      adw-gtk3
      yaru-theme
    ];
  };

  programs.gpaste.enable = true;

  qt.enable = true;

  services = {
    # Disable the event list of the calendar menu
    # gnome.evolution-data-server.enable = lib.mkForce false;

    xserver = {
      desktopManager.gnome = {
        enable = true;
        extraGSettingsOverrides = ''
          [org.gnome.desktop.peripherals.touchpad]
          tap-to-click=true
        '';
        extraGSettingsOverridePackages = with pkgs; [
          gsettings-desktop-schemas
        ];
      };
      displayManager.gdm.enable = true;
    };
  };

  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "autovt@tty1".enable = false;
    "getty@tty1".enable = false;
  };
}