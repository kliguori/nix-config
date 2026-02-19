{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (cfg.systemType == "server") {
    systemOptions = {
      desktop.enable = false;
      services = {
        # reverseProxy.enable = lib.mkDefault true;
        # vaultwarden.enable = lib.mkDefault true;
        # jellyfin.enable = lib.mkDefault true;
        # paperless = {
        #   enable = lib.mkDefault true;
        #   database.enable = lib.mkDefault true;
        # };
        postgresql.enable = lib.mkDefault true;
      };
    };
  };
}
