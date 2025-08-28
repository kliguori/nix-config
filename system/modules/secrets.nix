# Base sops-nix configuration usable by all hosts
{ lib, inputs, config, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    # Use a dedicated age key for the machine. If absent, generate:
    #   sudo mkdir -p /var/lib/sops-nix
    #   sudo age-keygen -o /var/lib/sops-nix/key.txt
    age.keyFile = "/var/lib/sops-nix/key.txt";

    # You can also leverage the host SSH key as a decryption key:
    # age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  };
}
