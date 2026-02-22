{ inputs, hostName, pkgs, ... }:
{
  # --- Imports ---
  imports = [
    inputs.nixos-hardware.nixosModules.common-cpu-intel
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
    hostId = "b709b6b5";
  };

  # --- Sudo w/o password ---
  security.sudo.wheelNeedsPassword = false;

  # --- Force Wayland to use Intel GPU ---
  environment.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/card1"; # card1 is intel card0 nvidia
  };

  # --- Set profile to "cool" ---
  systemd.services.set-platform-profile = {
    description = "Set Dell platform profile to cool";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c "echo cool > /sys/firmware/acpi/platform_profile"
      '';
    };
  };

  # --- System options ---
  systemOptions = {
    users = [
      "root"
      "admin"
      "kevin"
    ];
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
      # paperless = {
      #   dataDir = "/data/paperless";
      #   consumptionDir = "/data/paperless/consume";
      # };
      vaultwarden.dataDir = "/data/vaultwarden";
      postgresql.dataDir = "/data/postgresql";
    };
  };
}
