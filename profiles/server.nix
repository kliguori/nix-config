{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (cfg.systemType == "server") {
    systemOptions = {
      desktop.enable = lib.mkDefault false;
      tls.enable = lib.mkDefault true;
      services = {
        postgresql = {
          enable = lib.mkDefault true;
          dataDir = "/data/postgresql";
        };
        nginx.enable = lib.mkDefault true;
        jellyfin.enable = lib.mkDefault true;
        vaultwarden = {
          enable = lib.mkDefault true;
          dataDir = "/data/vaultwarden";
        };
        # paperless = {
        #   enable = lib.mkDefault true;
        #   database.enable = lib.mkDefault true;
        # };
      };
    };
  };
}
