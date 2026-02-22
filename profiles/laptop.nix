{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (lib.elem "laptop" cfg.profiles) {
    systemOptions = {
      services.powerManagement.enable = lib.mkDefault true;
    };
  };
}
