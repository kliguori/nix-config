{ lib, config, ... }:
let mkIf = lib.mkIf;
in
{
  services.tailscale.enable = true;

  my.persist.paths = mkIf config.my.persist.enable [
    { path = "/var/lib/tailscale"; mode = "0700"; }
    { path = "/etc/default/tailscaled"; }
  ];
}
