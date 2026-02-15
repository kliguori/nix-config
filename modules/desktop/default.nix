{ config, lib, pkgs, ... }:
let
  cfg = config.systemOptions.desktop;
in
{
  options.systemOptions.desktop = {
    enable = lib.mkEnableOption "Graphical desktop environment";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      niri.enable = true;
      thunar.enable = true;
      firefox.enable = true; 
      dank-material-shell.greeter = {
        enable = true;
        compositor.name = "niri";
      };
    };

    environment = {
      systemPackages = with pkgs; [
        kitty
        alacritty
      ];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };
  };
}
