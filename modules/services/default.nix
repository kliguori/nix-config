{ config, lib, ... }:
let
  cfg = config.systemOptions.services;
in
{
  options.systemOptions.services = {
    ssh = {
      enable = lib.mkEnableOption "OpenSSH server";

      passwordAuthentication = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allow SSH password authentication.";
      };

      permitRootLogin = lib.mkOption {
        type = lib.types.enum [ "yes" "no" "prohibit-password" "without-password" ];
        default = "no";
        description = "Permit root login via SSH.";
      };
    };

    fstrim = {
      enable = lib.mkEnableOption "Periodic TRIM for SSD/NVMe";
    };

    tailscale = {
      enable = lib.mkEnableOption "Tailscale VPN client";
    };

    powerManagement = {
      enable = lib.mkEnableOption "UPower and power-profiles-daemon for battery/power management (laptops)";
    };
  };

  config = lib.mkMerge [
    # --- OpenSSH ---
    (lib.mkIf cfg.ssh.enable {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = cfg.ssh.passwordAuthentication;
          PermitRootLogin = cfg.ssh.permitRootLogin;
        };
      };
      environment.persistence."/persist".directories =
        lib.mkIf config.systemOptions.impermanence.enable [ "/etc/ssh" ];
    })
    
    # --- Fstrim ---
    (lib.mkIf cfg.fstrim.enable {
      services.fstrim.enable = true;
    })

    # --- Tailscale ---
    (lib.mkIf cfg.tailscale.enable {
      services.tailscale.enable = true;
      environment.persistence."/persist".directories =
        lib.mkIf config.systemOptions.impermanence.enable [ "/var/lib/tailscale" ];
    })

    # --- Power Management (laptops) ---
    (lib.mkIf cfg.powerManagement.enable {
      services.upower.enable = true;
      services.power-profiles-daemon.enable = true;
    })
  ];
}
