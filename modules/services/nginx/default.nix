{ config, lib, ... }:
let
  cfg = config.systemOptions.services.nginx;
  tlsEnabled = config.systemOptions.tls.enable;

  ports =
    if tlsEnabled then
      [
        80
        443
      ]
    else
      [ 80 ];

  firewallConfig =
    if cfg.exposeInterfaces == null then
      { allowedTCPPorts = ports; }
    else
      {
        interfaces = lib.genAttrs cfg.exposeInterfaces (_: {
          allowedTCPPorts = ports;
        });
      };
in
{
  options.systemOptions.services.nginx = {
    enable = lib.mkEnableOption "Nginx platform";

    baseDomain = lib.mkOption {
      type = lib.types.str;
      default = "liguorihome.com";
      description = "Base domain used by service modules when registering vhosts (e.g. jellyfin.<baseDomain>).";
    };

    exposeInterfaces = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = "Interfaces to expose nginx on. Null = all interfaces.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall ports for nginx.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
    };
    networking.firewall = lib.mkIf cfg.openFirewall firewallConfig;
  };
}
