{
  config,
  lib,
  pkgs,
  ...
}:
let
  enabled = lib.elem "kevin" config.systemOptions.users;
  sopsFile = ../../secrets/secrets.yaml;
in
lib.mkIf enabled {
  sops.secrets.kevinPassword = {
    inherit sopsFile;
    neededForUsers = true;
    key = "users/kevin/hashedPassword";
    owner = "root";
    group = "root";
    mode = "0400";
  };

  users.users.kevin = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Kevin Liguori";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPasswordFile = config.sops.secrets.kevinPassword.path;
    openssh.authorizedKeys.keys = [ ];
  };
}
