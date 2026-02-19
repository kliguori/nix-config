{ config, lib, ... }:
let
  cfg = config.systemOptions.services.paperless;
in
{
  options.systemOptions.services.paperless = {
    enable = lib.mkEnableOption "Paperless-ngx document manager";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open Paperless port directly. Prefer exposing via reverse proxy.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/paperless";
      description = "Directory to store Paperless data (must be persistent).";
    };

    consumptionDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Directory to watch for new documents.";
    };

    database = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Use a local database. Disable only if using an external DB.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "paperless";
        description = "PostgreSQL database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "paperless";
        description = "PostgreSQL role/user name.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !cfg.database.enable || (config.systemOptions.services.postgresql.enable or false);
        message = "systemOptions.services.postgresql.enable must be true when paperless.database.enable is true";
      }
    ];

    services.paperless = {
      enable = true;
      dataDir = toString cfg.dataDir;
      consumptionDir = lib.mkIf (cfg.consumptionDir != null) (toString cfg.consumptionDir);
      database.createLocally = cfg.database.enable;
    };

    services.postgresql = lib.mkIf cfg.database.enable {
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ 28981 ];
  };
}
