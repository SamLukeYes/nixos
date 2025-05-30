{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    shijima-qt
  ];

  users.persistence.directories = [
    ".local/share/Shijima-Qt"
  ];
}