{ config, lib, ... }:
let
  enabledUsers = config.systemOptions.users;
  userModules = {
    root = ./root;
    admin = ./admin;
    kevin = ./kevin;
  };
  selectedUsers = builtins.attrValues (
    lib.filterAttrs (name: _: lib.elem name enabledUsers) userModules
  );
in
{
  options.systemOptions.users = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ ];
    description = "List of users to enable on system.";
  };

  imports = selectedUsers;
}
