{ config, lib, ... }:
let
  cfg = config.systemOptions.services.jellyfin;
  rpEnabled = config.systemOptions.services.reverseProxy.enable or false;
in
{
  options.systemOptions.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open Jellyfin ports directly (8096/8920). Prefer reverse proxy.";
    };

    enableDiscovery = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open UDP discovery ports (1900, 7359). Typically LAN-only.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin.enable = true;

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      8096
      8920
    ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.enableDiscovery [
      1900
      7359
    ];

    warnings =
      lib.optional (rpEnabled && cfg.openFirewall)
        "jellyfin.openFirewall = true while reverseProxy is enabled; this exposes Jellyfin directly.";

    services.nginx.virtualHosts = lib.mkIf rpEnabled (
      let
        rp = config.systemOptions.services.reverseProxy;
        tls = rp.enableTLS or false;
        vhostName = "jellyfin.${rp.baseDomain}";
      in
      {
        ${vhostName} = {
          enableACME = tls;
          forceSSL = tls;

          locations."/" = {
            proxyPass = "http://127.0.0.1:8096";
            proxyWebsockets = true;
          };
        };
      }
    );
  };
}
