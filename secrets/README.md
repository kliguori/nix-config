# Secrets scaffold (sops-nix)

This repo expects *one encrypted secret file per user password*:

```
secrets/
└── users/
    └── kevin.password     # sops-encrypted file, contains the *hashed* password
```

## 1) Generate or reuse an age key on each machine

```bash
sudo mkdir -p /var/lib/sops-nix
sudo age-keygen -o /var/lib/sops-nix/key.txt
sudo chmod 600 /var/lib/sops-nix/key.txt
```

(Alternatively, set `sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];` in `system/modules/secrets.nix`.)

## 2) Create a hashed password (SHA-512)

```bash
mkpasswd -m sha-512  # paste your password when prompted
```

Copy the resulting hash.

## 3) Create and encrypt the per-user file

```bash
mkdir -p secrets/users
printf '%s' '$6$EXAMPLE....' > secrets/users/kevin.password
sops --encrypt --age $(cat /var/lib/sops-nix/key.txt | grep -o 'public key:.*' | awk '{print $3}') \
  --in-place secrets/users/kevin.password
```

(Or use your preferred `sops` method to encrypt with your age recipients.)

> The file should contain **only** the hash string (no newline).  
> The NixOS module reads it as `hashedPasswordFile`.

## 4) Rebuild

```bash
sudo nixos-rebuild switch --flake .#watson
```

Because `users.mutableUsers = false`, passwords MUST be provided via sops before the first switch.
