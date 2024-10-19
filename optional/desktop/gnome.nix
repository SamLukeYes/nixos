{ lib, pkgs, ... }:

{
  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome.excludePackages = with pkgs; [
      gnome-shell-extensions        # use the standalone extensions
      epiphany                      # use firefox instead
      gnome-text-editor             # use vscode instead
      gnome-calculator              # use xonsh instead
      gnome-console                 # use blackbox-terminal instead
      gnome-contacts                # useless on PC
      gnome-maps                    # use online maps instead
      gnome-music                   # use celluloid instead
      gnome-weather                 # use MSN weather instead
      simple-scan                   # no scanner available
      totem                         # use celluloid instead
      evince                        # use web browser for pdf
      geary                         # use web browser instead
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
      celluloid
      endeavour
      gimp
      gnome-firmware
      gnome-sound-recorder
      gnome-tweaks
      libreoffice
      roxterm

      # nautilus extensions
      nautilus-python
      (runCommand "nautilus-open-roxterm" { } ''
        mkdir -p $out/share/nautilus-python/extensions
        sed 's|"gnome-terminal"|"roxterm"|g' \
          ${nautilus-python.doc}/share/doc/nautilus-python/examples/open-terminal.py \
          > $out/share/nautilus-python/extensions/open-roxterm.py
      '')

      # GNOME Shell extensions
      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.easyScreenCast
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
          [org.gnome.mutter]
          experimental-features=['scale-monitor-framebuffer']
        '';
        extraGSettingsOverridePackages = with pkgs; [
          gsettings-desktop-schemas
          mutter
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