{ config, lib, ... }:
let
  cfg = config.systemOptions.services.jellyfin;
in
{
  options.systemOptions.services.jellyfin = {
    enable = lib.mkEnableOption "Jellyfin media server";

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Open firewall ports for Jellyfin";
    };

    mediaDir = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to the media library";
    };
  };

  config = lib.mkIf cfg.enable {
    services.jellyfin.enable = true;

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 8096 8920 ];
      allowedUDPPorts = [ 1900 7359 ];
    };

    environment.persistence."/persist".directories =
      lib.mkIf config.systemOptions.impermanence.enable [
        "/var/lib/jellyfin"
        "/var/cache/jellyfin"
      ];
  };
}
