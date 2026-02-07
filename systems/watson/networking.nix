{ lib, hostName, ... }:
{
  networking = {
    hostName = hostName;
    hostId = "a8c07b12";
    useDHCP = lib.mkDefault true;
    networkmanager.enable = true;

    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
      logRefusedConnections = true;
    };
  };
}
