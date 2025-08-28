{
  description = "Standalone Home Manager flake (portable to NixOS, nix-darwin, or HM-standalone)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    lib   = nixpkgs.lib;
    systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    forAll = f: lib.genAttrs systems (system: f (import nixpkgs { inherit system; }));
  in
  {
    # Example standalone configs you can build/apply by name:
    homeConfigurations = {
      "kevin@workstation" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "x86_64-linux"; };
        modules = [
          ./profiles/workstation.nix
          { home.username = "kevin"; home.homeDirectory = "/home/kevin"; }
        ];
      };
    };
  };
}
