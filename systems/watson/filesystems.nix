{ ... }:
{
  fileSystems = {
    "/" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=0755" ];
    };
    "/nix".neededForBoot = true;
    "/persist".neededForBoot = true;
  };
}
