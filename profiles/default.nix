{ lib, pkgs, ... }:
{
  imports = [
    ./laptop.nix
    ./desktop.nix
    ./server.nix
  ];

  options.systemOptions.systemType = lib.mkOption {
    type = lib.types.enum [ "laptop" "desktop" "server" ];
    description = "The role of this system. Required, no default.";
  };

  config = {
    # --- System options
    systemOptions = {
      desktop.enable = lib.mkDefault true;
      services = {
        ssh.enable = lib.mkDefault true;
        fstrim.enable = lib.mkDefault true;
        tailscale.enable = lib.mkDefault true;
        powerManagement.enable = lib.mkDefault true;
      };
    };

    # --- Nixpkgs settings ---
    nixpkgs.config.allowUnfree = true;

    # --- Nix settings ---
    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
        trusted-users = [ "@wheel" ];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
    };

    # --- Immuatable users ---
    users.mutableUsers = lib.mkForce false;

    # --- Networking ---
    networking = {
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
      supportedFilesystems = [ 
        "btrfs" 
        "zfs"
      ];
    };
    
    # --- Hardware ---
    hardware.enableAllFirmware = true;

    # --- Disable X ---
    services.xserver.enable = false;

    # --- Localization ---
    time.timeZone = lib.mkDefault "America/New_York";
    i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

    # --- Packages ---
    environment.systemPackages = with pkgs; [
      tree
      pciutils
      unzip
      neovim
      curl
      wget
      eza
      jq
      dnsutils
      iproute2
      iputils
      nmap
      traceroute
      htop
      strace
      lsof
      ripgrep
      fd
      bat
      duf
      ncdu
      rsync
      parted
      git
      usbutils
      lm_sensors
      fwupd
      sops
      age
    ];
  };
}
