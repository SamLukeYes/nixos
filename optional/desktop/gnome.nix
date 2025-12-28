{ lib, pkgs, ... }:

{
  imports = [
    ../dm/gdm.nix
  ];

  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/desktop-managers/gnome.nix
    gnome.excludePackages = with pkgs; [
      gnome-shell-extensions        # use the standalone extensions
      decibels                      # use celluloid instead
      epiphany                      # use firefox instead
      gnome-calculator              # use xonsh instead
      gnome-calendar                # not syncing calendar to PC
      gnome-contacts                # useless on PC
      gnome-maps                    # use online maps instead
      gnome-music                   # use celluloid instead
      gnome-weather                 # use MSN weather instead
      papers                        # use web browser for pdf
      showtime                      # use celluloid instead
      simple-scan                   # no scanner available
      geary                         # use web browser instead
    ];

    variables = {
      # Allow apps to detect gstreamer plugins
      GST_PLUGIN_PATH_1_0 = ["/run/current-system/sw/lib/gstreamer-1.0"];

      QT_WAYLAND_DECORATION = "adwaita";
    };

    sessionVariables = {
      # https://github.com/NixOS/nixpkgs/issues/469503
      XDG_DATA_DIRS = [
        "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
      ];
    };

    systemPackages = with pkgs; [
      celluloid
      file-roller
      gnome-firmware
      gnome-sound-recorder
      refine

      # nautilus extensions
      nautilus-python

      # GNOME Shell extensions
      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.ddterm
      gnomeExtensions.easyScreenCast
      gnomeExtensions.places-status-indicator
      gnomeExtensions.system-monitor-next
      gnomeExtensions.todotxt

      # GStreamer plugins
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-vaapi

      # Qt plugins
      qadwaitadecorations
      qadwaitadecorations-qt6
      qt6.qtwayland

      # CLI programs required by file-roller
      _7zz
      binutils

      # themes
      yaru-theme
    ];
  };

  programs.gpaste.enable = true;

  qt.enable = true;

  services = {
    # Disable the event list of the calendar menu
    gnome.evolution-data-server.enable = lib.mkForce false;

    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org.gnome.desktop.peripherals.touchpad]
        tap-to-click=true
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
      extraGSettingsOverridePackages = with pkgs; [
        gsettings-desktop-schemas
        mutter
      ];
    };
  };

  users.persistence = {
    directories = [
      ".cache/tracker3"

      ".config/gsconnect"
      ".config/gtk-3.0"  # nautilus bookmarks

      ".local/share/gnome-remote-desktop"
      ".local/share/gpaste"
      ".local/share/keyrings"
      ".local/share/nautilus"
      ".local/share/org.gnome.SoundRecorder"
      { directory = ".local/share/todo.txt"; how = "symlink"; }
    ];
  };
}