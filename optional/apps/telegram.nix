{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.telegram-desktop ];

  users.persistence.directories = [
    ".local/share/TelegramDesktop"
  ];
}