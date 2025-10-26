{ ... }:

{
  programs.adb.enable = true;

  users.persistence.directories = [
    ".android"
  ];
}