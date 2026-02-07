{
  config,
  lib,
  pkgs,
  hostName,
  hostId,
  ...
}:

{
  networking = {
    hostName = hostName;
    hostId = hostId;
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
