{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (cfg.systemType == "laptop") {
    systemOptions = {
      services.powerManagement.enable = lib.mkDefault true;
    };
  };
}
