{
  sherlock = {
    profile   = "workstation";
    isLaptop  = false;
    gpu       = "nvidia";
    persist   = { enable = true; root = "/persist"; };
    # Users by group bucket + explicit users
    userGroups = [ "admins" "media" ];
    users      = [ "kevin" ];
    # Home Manager policy for this host
    home = {
      manage = false;        # leave HM fully to the user (separable)
      users  = [ "kevin" ];  # who to manage *if* manage = true
      profileOverride = null;# or "workstation" to force a specific HM profile
    };
  };

  watson = {
    profile   = "laptop";
    isLaptop  = true;
    gpu       = "intel";
    persist   = { enable = true; root = "/persist"; };
    userGroups = [ "admins" ];
    users      = [ "kevin" ];
    home = { manage = true; users = [ "kevin" ]; profileOverride = null; };
  };

  mycroft = {
    profile   = "server";
    isLaptop  = false;
    gpu       = null;
    persist   = { enable = true; root = "/persist"; };
    userGroups = [ "admins" "services" ];
    users      = [ ];
    home = { manage = false; users = [ ]; profileOverride = null; };
  };
}
