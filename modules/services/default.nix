{ ... }:
{
  imports = [
    ./ssh
    ./fstrim
    ./tailscale
    ./powerManagement
    ./reverseProxy
    # ./vaultwarden
    ./jellyfin
    # ./paperless
    # ./postgreSQL
  ];
}
