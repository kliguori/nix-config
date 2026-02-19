{ config, lib, ... }:
let
  cfg = config.systemOptions.services.paperless;
in
{
  options.systemOptions.services.paperless = {
    enable = lib.mkEnableOption "Paperless-ngx document manager";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall port for Paperless-ngx";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to store paperless data. Must be on a persistent drive.";
    };

    consumptionDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Directory to watch for new documents";
    };

    database = {
      enable = lib.mkEnableOption "PostgreSQL database for Paperless-ngx";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.database.enable || config.systemOptions.services.postgresql.enable;
        message = "systemOptions.services.postgresql.enable must be true when paperless database is enabled";
      }
    ];

    services.paperless = {
      enable = true;
      dataDir = cfg.dataDir;
      consumptionDir = lib.mkIf (cfg.consumptionDir != null) cfg.consumptionDir;
      database.createLocally = false;
    };

    services.postgresql = lib.mkIf cfg.database.enable {
      ensureDatabases = [ "paperless" ];
      ensureUsers = [
        {
          name = "paperless";
          ensureDBOwnership = true;
        }
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 28981 ];
  };
}
