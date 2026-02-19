{ config, lib, ... }:
let
  cfg = config.systemOptions.services;
in
{
  options.systemOptions.services = {
    tailscale = {
      enable = lib.mkEnableOption "Tailscale VPN client";
    };
  };

  config = lib.mkIf cfg.tailscale.enable {
    services.tailscale.enable = true;
    environment.persistence."/persist".directories = lib.mkIf config.systemOptions.impermanence.enable [
      "/var/lib/tailscale"
    ];
  };
}
