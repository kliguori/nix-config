{ inputs, hostName, lib, ... }:
{
  # --- Imports ---
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ../core 
    ../../modules 
    ../../users
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Networking ---
  networking = {
    hostName = hostName;
    hostId = "5dcafb0a";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;
  };

  # --- Boot settings ---
  boot = {
    kernelParams = [ ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = [ "btrfs" ];
  };

  # --- Hardware ---
  hardware.enableAllFirmware = true;

  # --- System options ---
  systemOptions = {
    impermanence.enable = true;
    desktop.enable = true;
    hibernate = {
      enable = true;
      resumeDevice = "/dev/vg/swap";
    };
    services = {
      ssh.enable = true;
      fstrim.enable = true;
      tailscale.enable = true;
      powerManagement.enable = true;
    };
  };
}
