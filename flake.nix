{
  description = "NixOS System Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    
    hosts = {
      sherlock = {
        system = "x86_64-linux";
        hostId = "d302d58e"; # Generate hostID with: head -c4 /dev/urandom | od -An -tx1 | tr -d ' \n'
        sshKey = "ssh-ed25519 AAAA... sherlock";
      };
    
       watson = {
        system = "x86_64-linux";
        hostId = "a8c07b12"; # Generate hostID with: head -c4 /dev/urandom | od -An -tx1 | tr -d ' \n'
        sshKey = "ssh-ed25519 AAAA... watson";
      };
    };

    mkSystem = { hostName, hostId, system }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hostName hostId; };
        modules = [
          ./systems/${hostName}
          inputs.impermanence.nixosModules.impermanence
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.disko 
          inputs.agenix.nixosModules.default
	  
          # Home manager config
	  {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "backup";
	      extraSpecialArgs = { inherit hostName hostId };
              users.kevin = import ./home;
            };
	  }

	  # Disko config
	  { disko.devices = import ./systems/${hostName}/disko.nix; }
        ];
      };
  in
  {
    nixosConfigurations =
      nixpkgs.lib.mapAttrs
        (hostName: cfg:
          mkSystem {
            inherit hostName;
            system = cfg.system;
            hostId = cfg.hostId;
          }
        ) hosts;
  };
}
