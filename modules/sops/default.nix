{ config, lib, ... }:
let
  persist = config.systemOptions.impermanence.enable;
  baseDir = "/var/lib/sops-nix";

  keyFile = 
    if persist 
    then "/persist${baseDir}/key.txt" 
    else "${baseDir}/key.txt"; 
in
{
  sops = {
    age = {
      inherit keyFile; 
      generateKey = true;
      sshKeyPaths = lib.mkForce [ ];
    };
    gnupg.sshKeyPaths = lib.mkForce [ ];
  };

  environment.persistence."/persist".directories = lib.mkIf persist [ baseDir ];
}
