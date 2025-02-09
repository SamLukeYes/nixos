{ lib, ... }:

{
  options.users.persistence = {
    directories = lib.mkOption {
      default = [];
      type = with lib.types; listOf anything;
    };
    files = lib.mkOption {
      default = [];
      type = with lib.types; listOf anything;
    };
  };
}