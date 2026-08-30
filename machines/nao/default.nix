# Nao is a Home Manager module that is used in the Terminal App on Aikawa

{ config, lib, pkgs, ... }:

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
  home.packages = with pkgs; [
    deploy-rs  # deploy VPS from Aikawa
    nil  # nix lsp
    yt-dlp-light  # download music
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".xonshrc".text = ''
      source-bash ~/.nix-profile/etc/profile.d/hm-session-vars.sh
      source ~/.xonshrc-unmanaged
      $PATH.insert(0, "~/.nix-profile/bin")
      $XONSH_COLOR_STYLE = 'native'
    '';
  };

  home.sessionVariables = {
    DISPLAY = ":0";
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
