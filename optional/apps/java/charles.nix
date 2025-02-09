{ config, pkgs, ... }:

{
  environment.systemPackages = [
    (pkgs.charles.override { jdk11 = config.programs.java.package; })
  ];

  users.persistence = {
    directories = [ ".charles" ];
    files = [ ".charles.config" ];
  };
}