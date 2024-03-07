{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.scrcpy ];

  programs = {
    adb.enable = true;
    # java.package = pkgs.jdk8;
  };
}