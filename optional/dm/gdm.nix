{ ... }:

{
  services.xserver.displayManager.gdm = {
    enable = true;
    debug = true;
  };

  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services = {
    "autovt@tty1".enable = false;
    "getty@tty1".enable = false;
  };
}