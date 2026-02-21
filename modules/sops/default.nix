{ config, lib, ... }:
let
  cfg = config.systemOptions;
  sopsDir = "/var/lib/sops-nix";
in
{
  sops = {
    age = {
      keyFile = "${sopsDir}/key.txt";
      generateKey = false;
      sshKeyPaths = lib.mkForce [ ];
    };
    gnupg.sshKeyPaths = lib.mkForce [ ];
  };

  environment.persistence."/persist".directories = lib.mkIf cfg.impermanence.enable [
    sopsDir
  ];
}
