{
  description = "NixOS config with profiles, sops-nix, immutable users, and separable Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    sops-nix.url = "github:Mic92/sops-nix";
    # Separate Home Manager flake (local path so you can use it standalone or inside this repo)
    home.url = "path:./home";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, home, ... }@inputs:
  let
    lib = nixpkgs.lib;
    # All host and user data lives outside the flake.
    hosts  = import ./data/hosts.nix;
    userdb = import ./data/userdb.nix;

    mkSystem = name: lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit hosts userdb inputs;
        homePath = home.outPath; # path to the separate Home Manager flake
      };
      modules = [
        # Core shared modules
        ./system/modules/_options.nix
        ./system/modules/secrets.nix         # sops-nix base config
        ./system/modules/networking.nix
        ./system/modules/tailscale.nix
        ./system/modules/persist.nix
        ./system/modules/virtualization.nix
        ./system/modules/desktop.nix
        ./system/modules/users.nix
        ./system/modules/systemd.nix
        ./system/modules/home-bridge.nix     # optional HM wiring (per-host toggle)

        # Per-host hardware/disk only
        ./system/hosts/nixos/${name}/hardware.nix
        (lib.optional (builtins.pathExists ./system/hosts/nixos/${name}/disko.nix)
          ./system/hosts/nixos/${name}/disko.nix)

        # Publish host facts
        { my = hosts.${name}; networking.hostName = name; }
        # Make userdb available to modules as my.userdb
        { my.userdb = userdb; }
      ];
    };
  in {
    nixosConfigurations = lib.genAttrs (builtins.attrNames hosts) mkSystem;
  };
}
