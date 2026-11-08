{ ... }:

{
  imports = [
    ../../common/programs/git.nix
    ../../common/programs/xonsh.nix
    ../../common/services/angrr.nix
    ../../common/i18n.nix
    ../../common/nix.nix
  ];

  avf.vmConfig.sharedPath = [
    {
      sharedPath = "/storage/emulated";
    }
    {
      sharedPath = "$APP_DATA_DIR/files";
    }
  ];

  networking.hostName = "nao";
}