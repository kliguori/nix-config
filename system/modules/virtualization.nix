{ lib, config, ... }:
let
  mkIf = lib.mkIf;
  p = config.my.profile;
in
{
  # KVM for non-laptops
  virtualisation.libvirtd.enable = mkIf (p != "laptop") true;
  programs.virt-manager.enable   = mkIf (p == "workstation") true;

  # Containers
  virtualisation.docker.enable   = mkIf (p == "laptop") true;
  virtualisation.podman.enable   = mkIf (p != "laptop") true;
  virtualisation.podman.dockerCompat = mkIf (p != "laptop") true;
}
