{
  description = "NixOS System Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    impermanence.url = "github:nix-community/impermanence";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
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

  outputs = inputs@{ self, nixpkgs, nix-darwin, ... }:
  let
    hostsNixOS = {
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

    hostsDarwin = {
      macbook = {
        system = "aarch64-darwin";
        sshKey = "ssh-ed25519 AAAA... macbook";
      };
    };

    # Function to make NixOS systems
    mkNixOS = { hostName, hostId, system }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs hostName hostId; };
        modules = [
          ./systems/${hostName}
          inputs.impermanence.nixosModules.impermanence
          inputs.home-manager.nixosModules.home-manager
          inputs.disko.nixosModules.disko 
          inputs.agenix.nixosModules.default
	        {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "backup";
	            extraSpecialArgs = { inherit inputs hostName hostId; };
              users.kevin.imports = [
                inputs.nixvim.homeManagerModules.nixvim
                ./home
              ];
            };
	        }
          { disko.devices = import ./systems/${hostName}/disko.nix; }
        ];
      };

    # Function to make Darwin systems
    mkDarwin = { hostName, system }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        specialArgs = { inherit inputs hostName; };
        modules = [
          ./systems/${hostName}
          inputs.home-manager.darwinModules.home-manager
	        {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "backup";
	            extraSpecialArgs = { inherit inputs hostName; };
              users.kevin.imports = [
                inputs.nixvim.homeManagerModules.nixvim
                ./home
              ];
            };
	        }
        ];
      };
  in
  {
    nixosConfigurations =
      nixpkgs.lib.mapAttrs
        (hostName: cfg:
          mkNixOS {
            inherit hostName;
            system = cfg.system;
            hostId = cfg.hostId;
          }
        ) hostsNixOS;

    darwinConfigurations =
      nixpkgs.lib.mapAttrs
        (hostName: cfg:
          mkDarwin {
            inherit hostName;
            system = cfg.system;
          }
        ) hostsDarwin;
  };
}
