{ ... }:
{
  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/persist" = {
      device = "rpool/persist";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/home" = {
      device = "hpool/home";
      fsType = "zfs";
      neededForBoot = true;
    };

    "/scratch" = {
      device = "spool/scratch";
      fsType = "zfs";
      options = [ "nofail" ];
    };
  };
}
