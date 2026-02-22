{ config, lib, ... }:
let
  cfg = config.systemOptions.services.jellyfin;
  nginx = config.systemOptions.services.nginx;
  tls = config.systemOptions.tls;

  nginxEnabled = nginx.enable;
  tlsEnabled = tls.enable;

  host = "jellyfin.${nginx.baseDomain}";
in
{
  options.systemOptions.services.jellyfin.enable = lib.mkEnableOption "Jellyfin media server";

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = nginxEnabled;
        message = "jellyfin.enable requires nginx.enable = true.";
      }
      {
        assertion = tlsEnabled;
        message = "jellyfin.enable requires tls.enable = true.";
      }
    ];

    services = {
      jellyfin.enable = true;
      nginx.virtualHosts."${host}" = {
        useACMEHost = nginx.baseDomain;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8096";
          proxyWebsockets = true;
        };
      };
    };
  };
}
