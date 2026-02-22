{
  config,
  lib,
  ...
}:
let
  cfg = config.systemOptions.services.vaultwarden;
  nginx = config.systemOptions.services.nginx;
  pg = config.systemOptions.services.postgresql;
  tls = config.systemOptions.tls;

  tlsEnabled = tls.enable;
  nginxEnabled = nginx.enable;
  pgEnabled = pg.enable;

  scheme = if tlsEnabled then "https" else "http";
  host = "vault.${nginx.baseDomain}";
  dbName = "vaultwarden";
  dbUser = "vaultwarden";
in
{
  options.systemOptions.services.vaultwarden = {
    enable = lib.mkEnableOption "Vaultwarden password manager";

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/vaultwarden";
      description = "Directory to store Vaultwarden data (must be persistent).";
    };

    signupsAllowed = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Allow new user signups.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = pgEnabled;
        message = "vaultwarden.enable requires postgresql.enable = true.";
      }
      {
        assertion = nginxEnabled;
        message = "vaultwarden.enable requires nginx.enable = true.";
      }
      {
        assertion = tlsEnabled;
        message = "vaultwarden.enable requires tls.enable = true.";
      }
    ];

    systemd = {
      services.vaultwarden.serviceConfig.ReadWritePaths = [
        (toString cfg.dataDir)
      ];

      tmpfiles.rules = [
        "d ${toString cfg.dataDir} 0750 vaultwarden vaultwarden -"
      ];
    };

    services = {
      vaultwarden = {
        enable = true;
        dbBackend = "postgresql";
        config = {
          ROCKET_ADDRESS = "127.0.0.1";
          DATA_FOLDER = toString cfg.dataDir;
          ROCKET_PORT = 8222;
          WEBSOCKET_ENABLED = true;
          SIGNUPS_ALLOWED = cfg.signupsAllowed;
          DATABASE_URL = "postgresql://${dbUser}@/${dbName}?host=/run/postgresql";
          DOMAIN = "${scheme}://${host}";
        };
      };

      postgresql = {
        ensureDatabases = [ dbName ];
        ensureUsers = [
          {
            name = dbUser;
            ensureDBOwnership = true;
          }
        ];
      };

      nginx.virtualHosts."${host}" = {
        enableACME = tlsEnabled;
        forceSSL = tlsEnabled;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8222";
          proxyWebsockets = true;
        };
      };
    };
  };
}
