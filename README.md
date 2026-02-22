# Nix-config

## Systems
- sherlock (desktop): Ryzen 9 and Nvidia 2080Ti 
- watson (laptop): Framework 13 w/ Ryzen 5
- mycroft (laptop, server): Dell XPS15 9500 w/ Intel and Nvidia
- lestrade (laptop): Lenovo ThinkPad T14 Gen 1 w/ Ryzen 7
- gregson (laptop): Dell Latitude 15 w/
- moriarty (usb): install and recovery w/ persistent storage

## To do:
- [ ] Allow multiple profiles, look at redoing profiles
- [ ] Paperless
- [ ] Nextcloud
- [ ] Remote access to network tailscale (headscale), netbird, wireguard, cloudflare tunnels, Unifi vpn?
- [ ] Set up outgoing vpn.
- [ ] Miniflux
- [ ] Uptime Kuma
- [ ] Prometheus
- [ ] Graphana
- [ ] Refactor mkSystem to a lib folder
- [ ] Audiobookshelf
- [ ] Immich
- [ ] ACME resolver still pointing to cloudflare... maybe change.
- [ ] Pi hole/DNS situation. Unbound?
- [ ] Simplify install with nix functions?
- [ ] Finish making sherlock config dendritic, re-evaluate disk configs and impermanence model
- [ ] Remove all traces of darwin from home manager configs
- [ ] Make home manager dendritic
- [ ] Firefox config including ad blocking
- [ ] DMS config 
- [ ] Lanzaboote
- [ ] Expose some services?
- [ ] Vim motions in terminal
- [ ] Re-evaluate terminal choice
- [x] Make impermanence the default
- [x] Vaultwarden
- [x] Add tls to domain name
- [x] Fix postgreSQL
- [x] SOPS-Nix
- [x] Make sure disko can add BTRFS subvols without being destructive
- [x] Get dms running on login
- [x] Jellyfin
- [x] Simplify niri config/keybinds
- [x] Move off unstable, except for what requires it
- [x] Reverse proxy
