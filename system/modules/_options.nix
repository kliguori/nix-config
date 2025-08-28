{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.my = {
    profile = mkOption {
      type = types.enum [ "server" "workstation" "laptop" ];
      default = "workstation";
      description = "High-level role that modules can switch on.";
    };

    isLaptop = mkOption { type = types.bool; default = false; };
    gpu      = mkOption { type = types.nullOr (types.enum [ "nvidia" "amd" "intel" ]); default = null; };

    persist = {
      enable = mkOption { type = types.bool; default = false; };
      root   = mkOption { type = types.str; default = "/persist"; };
      paths  = mkOption {
        type = types.listOf (types.submodule {
          options = {
            path  = mkOption { type = types.str; };
            mode  = mkOption { type = types.str; default = "0755"; };
            user  = mkOption { type = types.str; default = "root"; };
            group = mkOption { type = types.str; default = "root"; };
          };
        });
        default = [];
        description = "Dirs to ensure/perm (tmpfiles) and bind to persistence.";
      };
    };

    # Exposed user database (from data/userdb.nix)
    userdb = mkOption { type = types.attrs; default = {}; };

    # Home Manager control per host
    home = {
      manage = mkOption { type = types.bool; default = false; };
      users  = mkOption { type = types.listOf types.str; default = []; };
      profileOverride = mkOption { type = types.nullOr types.str; default = null; };
    };
  };
}
