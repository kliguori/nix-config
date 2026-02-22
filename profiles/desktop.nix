{ config, lib, ... }:
let
  cfg = config.systemOptions;
in
{
  config = lib.mkIf (lib.elem "desktop" cfg.profiles) {
  };
}
