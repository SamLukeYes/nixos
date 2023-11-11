{ config, lib, pkgs, ... }:

{
  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome.excludePackages = with pkgs.gnome; [
      epiphany                # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator        # use xonsh instead
      gnome-calendar          # broken with my local data
      pkgs.gnome-console      # use blackbox-terminal instead
      gnome-contacts          # not managing contacts on PC
      gnome-music             # use celluloid instead
      gnome-weather           # ugly as hell
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

      # This is already set in environment.variables by NixOS modules,
      # but it doesn't work with xonsh login shell and Qt6
      QT_WAYLAND_DECORATION = "adwaita";
    };

    systemPackages = with pkgs; [
      blackbox-terminal
      celluloid
      gnome.gnome-sound-recorder
      gnome.gnome-tweaks
      gnome.nautilus-python
      libreoffice

      # GNOME Shell extensions
      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.freon
      gnomeExtensions.pano
      gnomeExtensions.section-todo-list

      # CLI programs
      _7zz            # required by file-roller

      # themes
      adw-gtk3
      yaru-theme
    ];
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
    waylandDecoration = "adwaita";
  };

  services = {
    # Disable the event list of the calendar menu
    gnome.evolution-data-server.enable = lib.mkForce false;

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