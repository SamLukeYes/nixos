{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.scrcpy ];
  programs.adb.enable = true;
}