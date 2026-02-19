{ config, lib, ... }:
let
  cfg = config.systemOptions.services.postgresql;
in
{
  options.systemOptions.services.postgresql = {
    enable = lib.mkEnableOption "PostgreSQL database server";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to store PostgreSQL data. Must be on a persistent drive.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.postgresql = {
      enable = true;
      dataDir = cfg.dataDir;
    };
  };
}
