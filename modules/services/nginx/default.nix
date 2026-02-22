{ config, lib, ... }:
let
  cfg = config.systemOptions.services.nginx;
  tlsEnabled = config.systemOptions.tls.enable;
in
{
  options.systemOptions.services.nginx = {
    enable = lib.mkEnableOption "Nginx platform";

    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "liguorihome.com";
      description = "Base domain used by service modules when registering vhosts (e.g. jellyfin.<baseDomain>).";
    };

    # exposeInterfaces = lib.mkOption {
    #   type = lib.types.nullOr (lib.types.listOf lib.types.str);
    #   default = null;
    #   description = "Interfaces to expose nginx on. Null = all interfaces.";
    # };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = tlsEnabled;
        message = "nginx.enable requires tls.enable = true.";
      }
    ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
