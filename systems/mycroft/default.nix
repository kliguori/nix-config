{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}:
{
  # --- Imports ---
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop
    ./boot.nix
    ./networking.nix
    ./filesystems.nix
    ../modules/common.nix
    ../modules/nvidia.nix
    ../modules/persistence.nix
    ../../users
  ];

  # --- State version ---
  system.stateVersion = "25.11";

  # --- Services ---
  services = {
    blueman.enable = false; # Disable Blueman service
    pulseaudio.enable = false; # Disable pulseaudio
    zfs.autoScrub.enable = true; # Enable automatic scrubbing of ZFS pools
    tailscale.enable = true; # Enable  tailscale

    # Enable pipewire
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # Enable SSH
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };

  # --- Programs ---
  programs = {
    firefox.enable = true;
    thunar.enable = true;
    hyprland = {
      enable = false;
      withUWSM = false;
      xwayland.enable = false;
    };
  };

  # --- Security settings ---
  security.pam.services.hyprlock = { }; # For hyprlock to work

  # --- Packages ---
  # environment.systemPackages = with pkgs; [
  #   
  # ];

  # --- Wayland environment settings ---
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
