{ config, lib, ... }:
let
  cfg = config.systemOptions.services;
in
{
  options.systemOptions.services = {
    powerManagement = {
      enable = lib.mkEnableOption "UPower and power-profiles-daemon for battery/power management (laptops)";
    };
  };

  config = lib.mkIf cfg.powerManagement.enable {
    services.upower.enable = true;
    services.power-profiles-daemon.enable = true;
  };
}
