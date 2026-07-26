# Nao is a Home Manager module that is used in the Terminal App on Aikawa

{ ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "droid";
  home.homeDirectory = "/home/droid";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [ ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".xonshrc".text = ''
      source-bash /etc/profiles/per-user/droid/etc/profile.d/
      source ~/.xonshrc-unmanaged
      $XONSH_COLOR_STYLE = 'native'
    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/droid/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = { };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}