{ config, lib, ... }:
let
  cfg = config.systemOptions.services.vaultwarden;
  rpEnabled = config.systemOptions.services.reverseProxy.enable or false;
  pgEnabled = config.systemOptions.services.postgresql.enable or false;

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
    systemd.tmpfiles.rules = [
      "d ${toString cfg.dataDir} 0750 vaultwarden vaultwarden -"
    ];

    services.postgresql = lib.mkIf pgEnabled {
      ensureDatabases = [ dbName ];
      ensureUsers = [
        {
          name = dbUser;
          ensureDBOwnership = true;
        }
      ];
    };

    services.vaultwarden = {
      enable = true;
      dataDir = toString cfg.dataDir;
      config = {
        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        WEBSOCKET_ENABLED = true;
        SIGNUPS_ALLOWED = cfg.signupsAllowed;
      }
      // lib.optionalAttrs pgEnabled {
        DATABASE_URL = "postgresql://${dbUser}@/${dbName}?host=/run/postgresql";
      }
      // lib.optionalAttrs rpEnabled (
        let
          rp = config.systemOptions.services.reverseProxy;
          tls = rp.enableTLS or false;
          host = "vault.${rp.baseDomain}";
          scheme = if tls then "https" else "http";
        in
        {
          DOMAIN = "${scheme}://${host}";
        }
      );
    };

    services.nginx.virtualHosts = lib.mkIf rpEnabled (
      let
        rp = config.systemOptions.services.reverseProxy;
        tls = rp.enableTLS or false;
        host = "vault.${rp.baseDomain}";
      in
      {
        ${host} = {
          enableACME = tls;
          forceSSL = tls;

          locations."/" = {
            proxyPass = "http://127.0.0.1:8222";
            proxyWebsockets = true;
          };
        };
      }
    );
  };
}
