{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (cfg.systemType == "desktop") {
  };
}
