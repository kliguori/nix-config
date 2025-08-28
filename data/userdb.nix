{
  users = {
    kevin = {
      uid = 1000;
      description = "Kevin";
      extraGroups = [ "wheel" "networkmanager" "docker" ];
      shell = "/run/current-system/sw/bin/zsh";
      openssh = { authorizedKeys = [ "ssh-ed25519 AAAA... kevin@host" ]; };
    };
    # add more users here...
  };

  userGroups = {
    admins   = [ "kevin" ];
    media    = [ ];
    services = [ ];
  };
}
