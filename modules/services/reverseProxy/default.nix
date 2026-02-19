{ config, lib, ... }:
let
  cfg = config.systemOptions.services.reverseProxy;

  # Which ports nginx should expose
  ports =
    if cfg.enableTLS
    then [ 80 443 ]
    else [ 80 ];

  # Firewall configuration
  firewallConfig =
    if cfg.exposeInterfaces == null then
      {
        allowedTCPPorts = ports;
      }
    else
      {
        interfaces = lib.genAttrs cfg.exposeInterfaces (_: {
          allowedTCPPorts = ports;
        });
      };
in
{
  options.systemOptions.services.reverseProxy = {
    enable = lib.mkEnableOption "Reverse proxy (nginx) platform";

    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "liguorihome.com";
      description = "Base domain used by service modules when registering vhosts.";
    };

    enableTLS = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable TLS via ACME.";
    };

    acmeEmail = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Email used for ACME registration (required if enableTLS = true).";
    };

    exposeInterfaces = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "Interfaces to expose nginx on. Null means all interfaces.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall ports for nginx.";
    };
  };

  config = lib.mkIf cfg.enable {

    assertions =
      lib.optional cfg.enableTLS {
        assertion = cfg.acmeEmail != null;
        message = "reverseProxy.acmeEmail must be set when enableTLS = true";
      };

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };

    security.acme = lib.mkIf cfg.enableTLS {
      acceptTerms = true;
      defaults.email = cfg.acmeEmail;
    };

    networking.firewall =
      lib.mkIf cfg.openFirewall firewallConfig;
  };
}
