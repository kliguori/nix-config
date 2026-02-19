{ config, lib, ... }:
let
  cfg = config.systemOptions.services.postgresql;
in
{
  options.systemOptions.services.postgresql = {
    enable = lib.mkEnableOption "PostgreSQL database server";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/postgresql";
      description = "Directory to store PostgreSQL data (must be persistent).";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      dataDir = toString cfg.dataDir;
    };
  };
}
