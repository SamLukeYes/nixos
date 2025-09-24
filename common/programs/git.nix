{ pkgs, ... }:

{
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    gh
  ];

  users.persistence = {
    directories = [
      ".config/gh"
    ];
    files = [
      ".gitconfig"
    ];
  };
}