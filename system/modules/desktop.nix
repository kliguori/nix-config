{ lib, config, ... }:
let
  mkIf = lib.mkIf;
  p = config.my.profile;
in
{
  services.xserver.enable = mkIf (p != "server") true;
  programs.hyprland.enable = mkIf (p != "server") true;

  services.xserver.videoDrivers = mkIf (p != "server") (
    if      config.my.gpu == "nvidia" then [ "nvidia" ]
    else if config.my.gpu == "amd"    then [ "amdgpu" ]
    else [ "modesetting" ]
  );
}
