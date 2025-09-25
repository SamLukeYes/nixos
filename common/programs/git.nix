{ pkgs, ... }:

{
  programs.git.enable = true;

  environment.systemPackages = with pkgs; [
    gh
    jq  # required by gh-gonest
  ];

  users.persistence = {
    directories = [
      ".config/gh"
      ".local/share/gh"
    ];
    files = [
      ".gitconfig"
    ];
  };
}