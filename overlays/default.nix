{ unstablePkgs, ... }:
{
  nixpkgs.overlays = [ 
    (import ./unstable.nix unstablePkgs) 
  ];
}
