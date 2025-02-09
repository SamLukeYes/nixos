{ ... }:

{
  programs.gnupg.agent.enable = true;

  users.persistence.directories = [
    { directory = ".gnupg"; mode = "0700"; }
  ];
}