{ config, pkgs, ... }:
{
  sops.secrets.kevinPassword = {
    sopsFile = ./secrets.yaml;
    key = "password_hash";
    owner = "root";
    group = "root";
    mode = "0400";
  };

  users.users.kevin = {
    isNormalUser = true;
    description = "Kevin Liguori";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPasswordFile = config.sops.secrets.kevinPassword.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOavirFl6Xk3GR2bFfGzX28RYqfwld5lnBdSjTTCAV/0 kevin@macbook"
    ];

    # Shell
    shell = pkgs.zsh;
  };
}
