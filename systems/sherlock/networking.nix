{ lib, hostName, ... }:
{
  networking = {
    hostName = hostName;
    hostId = "d302d58e";
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
