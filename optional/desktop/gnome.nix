{ config, lib, pkgs, ... }:

{
  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome.excludePackages = with pkgs.gnome; [
      epiphany                # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator        # use xonsh instead
      pkgs.gnome-console      # use blackbox-terminal instead
      gnome-contacts          # not managing contacts on PC
      gnome-music             # use celluloid instead
      simple-scan             # no scanner available
      totem                   # use celluloid instead
      evince                  # use web browser for pdf
      geary                   # use web browser instead
    ];

    sessionVariables = {
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
      gnome.gnome-sound-recorder
      gnome.gnome-tweaks
      libreoffice

      # nautilus extensions
      gnome.nautilus-python
      nautilus-open-in-blackbox

      # GNOME Shell extensions
      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.pano
      gnomeExtensions.system-monitor-next
      gnomeExtensions.task-widget

      # Qt plugins
      adwaita-qt
      qadwaitadecorations-qt6
      qgnomeplatform
      qt6.qtsvg
      qt6.qtwayland

      # CLI programs
      _7zz            # required by file-roller

      # themes
      adw-gtk3
      yaru-theme
    ];
  };

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

  # workaroud for per-user language setting
  users.defaultUserShell = config.programs.xonsh.package;
}