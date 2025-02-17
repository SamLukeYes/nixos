{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.fastfetch ];

  users.persistence.directories = [
    { directory = ".local/share/fastfetch"; how = "symlink"; }
  ];
}