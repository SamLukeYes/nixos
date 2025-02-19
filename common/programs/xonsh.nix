{ pkgs, ... }:

{
  programs.xonsh = {
    enable = true;

    config = ''
      $LANG = "zh_CN.UTF-8"

      if __xonsh__.env.get("XDG_SESSION_TYPE") == "wayland":
          $GTK_IM_MODULE = ""
          $QT_IM_MODULE = ""
          $MOZ_ENABLE_WAYLAND = "1"
          $NIXOS_OZONE_WL = "1"
          $QT_QPA_PLATFORM = "wayland;xcb"
          $SDL_VIDEODRIVER = "wayland"

      # TODO: this shouldn't be necessary
      $SHELL_TYPE = "best"
    '';

    extraPackages = ps: with ps; [
      distro
      xonsh.xontribs.xonsh-direnv
    ];
  };

  environment.systemPackages = with pkgs; [
    starship
  ];

  users.persistence = {
    directories = [
      ".config/xonsh"
      ".local/share/xonsh"
    ];
    files = [
      ".config/starship.toml"
      ".xonshrc"
    ];
  };
}