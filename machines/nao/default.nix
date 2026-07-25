{ ... }:

{
  imports = [
    ../../common/environment
    ../../common/programs/direnv.nix
    ../../common/programs/git.nix
    ../../common/programs/misc-cli.nix
    ../../common/programs/pacman.nix
    ../../common/programs/xonsh.nix
    ../../common/services/angrr.nix
    ../../common/fonts.nix
    ../../common/i18n.nix
    ../../common/nix.nix
    ../../common/security.nix
    ../../optional/fonts
  ];

  boot.binfmt = {
    emulatedSystems = [ "x86_64-linux" ];
    preferStaticEmulators = true;
  };
}
