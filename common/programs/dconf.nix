{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    dconf-editor
  ];

  programs.dconf.enable = true;

  users.persistence.directories = [
    ".config/dconf"
  ];
}