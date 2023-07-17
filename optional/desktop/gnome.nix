{ config, lib, pkgs, ... }:

{
  environment = {
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/x11/desktop-managers/gnome.nix
    gnome.excludePackages = with pkgs.gnome; [
      epiphany                # use firefox instead
      pkgs.gnome-text-editor  # use vscode instead
      gnome-calculator        # use xonsh instead
      gnome-calendar          # broken with my local data
      gnome-contacts          # not managing contacts on PC
      gnome-music             # use celluloid instead
      gnome-weather           # ugly as hell
      simple-scan             # no scanner available
      totem                   # use celluloid instead
      evince                  # use web browser for pdf
      geary                   # use web browser instead
    ];

    sessionVariables.GST_PLUGIN_PATH_1_0 = lib.makeSearchPath "lib/gstreamer-1.0" (
      with pkgs.gst_all_1; [
        gst-plugins-bad
        gst-plugins-good
        gst-plugins-ugly
        gst-vaapi
      ]
    );

    systemPackages = with pkgs; [
      adw-gtk3
      celluloid
      gnome.gnome-sound-recorder
      gnome.gnome-tweaks
      gnome.nautilus-python
      libreoffice
      yaru-theme

      # GNOME Shell extensions
      gnomeExtensions.appindicator
      gnomeExtensions.customize-ibus
      gnomeExtensions.freon
      gnomeExtensions.one-drive-resurrect
      gnomeExtensions.pano
      gnomeExtensions.section-todo-list
    ];
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      libpinyin
    ];
  };

  programs.kdeconnect.package = pkgs.gnomeExtensions.gsconnect;

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