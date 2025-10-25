{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.foliate ];

  users.persistence.directories = [
    ".local/share/com.github.johnfactotum.Foliate"
  ];
}