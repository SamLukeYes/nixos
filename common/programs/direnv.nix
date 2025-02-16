{ ... }:

{
  programs.direnv.enable = true;

  users.persistence.directories = [
    ".local/share/direnv"
  ];
}