{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (cfg.systemType == "laptop") {
    systemOptions = {
      powerManagement.enable = lib.mkDefault true;
    };
  };
}
