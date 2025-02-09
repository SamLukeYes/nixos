{ ... }:

{
  programs.git.enable = true;

  users.persistence.files = [
    ".gitconfig"
  ];
}