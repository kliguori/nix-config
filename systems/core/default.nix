{ lib, pkgs, ... }:
{
  # --- Nixpkgs settings ---
  nixpkgs.config.allowUnfree = true;

  # --- Nix settings ---
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
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
  users.mutableUsers = false;

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
  ];
}
