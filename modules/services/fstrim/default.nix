{ config, lib, ... }:
let
  cfg = config.systemOptions.services;
in
{
  options.systemOptions.services = {
    fstrim = {
      enable = lib.mkEnableOption "Periodic TRIM for SSD/NVMe";
    };
  };

  config = lib.mkIf cfg.fstrim.enable {
    services.fstrim.enable = true;
  };
}
