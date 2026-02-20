{ inputs, hostName, ... }:
{
  # --- Imports ---
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ../../profiles
    ../../modules
    ../../users
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Networking ---
  networking = {
    hostName = hostName;
    hostId = "b709b6b5";
  };

  # --- Dell fan controll ---
  boot.kernelModules = [ "dell_smm_hwmon" ];
  # boot.extraModprobeConfig = ''
  #   options dell_smm_hwmon force=1 ignore_dmi=1
  # '';

  # --- System options ---
  systemOptions = {
    systemType = "server";
    desktop.enable = true;
    impermanence.enable = true;
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    services = {
      powerManagement.enable = true;
      reverseProxy.enable = true;
      jellyfin.enable = true;
      # paperless = {
      #   dataDir = "/data/paperless";
      #   consumptionDir = "/data/paperless/consume";
      # };
      # postgresql.dataDir = "/data/postgresql";
    };
  };
}
