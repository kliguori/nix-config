{ lib, config, ... }:
let mkIf = lib.mkIf;
in
{
  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.backend = mkIf config.my.isLaptop "iwd";

  # Example: persist NM connections on ephemeral root
  my.persist.paths = mkIf config.my.persist.enable [
    { path = "/etc/NetworkManager/system-connections"; mode = "0700"; }
  ];
}
