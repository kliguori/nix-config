{ lib, config, ... }:
let
  inherit (lib)
    mkIf mkMerge unique concatLists genAttrs attrNames attrValues;

  my     = config.my;
  users  = my.userdb.users or {};
  groups = my.userdb.userGroups or {};

  fromGroups = concatLists (map (g: (groups.${g} or [])) my.userGroups);
  chosenUsernames = unique (fromGroups ++ (my.users or []));

  # Build a users.users entry from userdb record
  mkUser = name: u: {
    users.users.${name} = {
      isNormalUser = true;
      uid          = u.uid or null;
      description  = u.description or "";
      extraGroups  = u.extraGroups or [];
      shell        = u.shell or "/run/current-system/sw/bin/bash";
      openssh.authorizedKeys.keys = u.openssh.authorizedKeys or [];
      # Password via sops-nix (immutable users)
      hashedPasswordFile = config.sops.secrets."users/${name}/password".path;
    };
  };

  # Secrets for each user's password hash (one file per user)
  mkSecret = name: {
    sops.secrets."users/${name}/password" = {
      # Create this encrypted file with sops; see secrets/README.md
      sopsFile = ../../secrets/users/${name}.password;
      format = "binary";
      owner = "root";
      group = "root";
      mode = "0400";
      neededForUsers = true; # decrypt early, before user creation
    };
  };
in
{
  # Immutable users globally
  users.mutableUsers = false;

  # Create users + their password secrets
  config = mkMerge (
    (map (n: mkUser n (users.${n} or {})) chosenUsernames)
    ++
    (map mkSecret chosenUsernames)
  );
}
