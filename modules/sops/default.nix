{ config, lib, ... }:
let
  cfg = config.systemOptions;
  sopsDir = "/var/lib/sops-nix";
in
{
  sops.age = {
    keyFile = "${sopsDir}/key.txt";
    generateKey = false;
  };

  environment.persistence."/persist".directories = lib.mkIf cfg.impermanence.enable [
    sopsDir
  ];
}
