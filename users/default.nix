{ lib, ... }:
{
  options.systemOptions.users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "List of users to enable on system.";
  };

  imports = [
    ./root
    ./admin
    ./kevin
  ];
}
