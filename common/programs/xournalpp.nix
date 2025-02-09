{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.xournalpp ];

  users.persistence.directories = [
    
  ];
}