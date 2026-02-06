{ config, lib, pkgs, hostName, ... }:
let
  isWatson = hostName == "watson";
in
{
  services.xserver = {
    enable = false; # disable xserver
    videoDrivers = [ "nvidia" ]; # Use nvidia video drivers
  };

  hardware = {
    graphics.enable = true; # Enable graphics hardware
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      prime = lib.mkIf isWatson {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };

      powerManagement = lib.mkIf isWatson {
        enable = true;
        finegrained = true;
      };
    };
  };
}
