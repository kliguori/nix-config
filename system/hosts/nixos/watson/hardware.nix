{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  # Replace this with your generated hardware-configuration.nix
}
