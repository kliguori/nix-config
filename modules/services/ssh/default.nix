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
        type = lib.types.enum [
          "yes"
          "no"
          "prohibit-password"
          "without-password"
        ];
        default = "no";
        description = "Permit root login via SSH.";
      };
    };
  };

  config = lib.mkIf cfg.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = cfg.ssh.passwordAuthentication;
        PermitRootLogin = cfg.ssh.permitRootLogin;
      };
    };
    environment.persistence."/persist".directories = lib.mkIf config.systemOptions.impermanence.enable [
      "/etc/ssh"
    ];
  };
}
