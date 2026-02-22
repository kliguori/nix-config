{ inputs, hostName, ... }:
{
  # --- Imports ---
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ../../modules
    ../../users
    ../../profiles
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Networking ---
  networking = {
    hostName = hostName;
    hostId = "5dcafb0a";
  };

  # --- System options ---
  systemOptions = {
    users = [
      "root"
      "kevin"
    ];
    systemType = "laptop";
    impermanence.enable = true;
    hibernate = {
      enable = true;
      resumeDevice = "/dev/vg/swap";
    };
  };
}
