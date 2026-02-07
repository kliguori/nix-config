{
  description = "NixOS and NixDarwin System Configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
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
    impermanence.url = "github:nix-community/impermanence";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      mkSystem =
        hostName: system:
        let
          isDarwin = nixpkgs.lib.hasSuffix "-darwin" system;

          homeManagerModule = {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              backupFileExtension = "backup";
              extraSpecialArgs = { inherit inputs hostName; };
              users.kevin.imports = [
                inputs.nixvim.homeModules.nixvim
                ./home
              ];
            };
          };

          diskoModule = {
            disko.devices = import ./systems/${hostName}/disko.nix;
          };

          platformModules =
            if isDarwin then
              [
                inputs.home-manager.darwinModules.home-manager
              ]
            else
              [
                inputs.impermanence.nixosModules.impermanence
                inputs.home-manager.nixosModules.home-manager
                inputs.agenix.nixosModules.default
                inputs.disko.nixosModules.disko
                diskoModule
              ];
        in
        (if isDarwin then nix-darwin.lib.darwinSystem else nixpkgs.lib.nixosSystem) {
          inherit system;
          specialArgs = { inherit inputs hostName; };
          modules = platformModules ++ [
            ./systems/${hostName}
            homeManagerModule
          ];
        };
    in
    {
      formatter = {
        x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
        aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
      };

      nixosConfigurations = {
        sherlock = mkSystem "sherlock" "x86_64-linux";
        watson = mkSystem "watson" "x86_64-linux";
      };

      darwinConfigurations = {
        macbook = mkSystem "macbook" "aarch64-darwin";
      };
    };
}
