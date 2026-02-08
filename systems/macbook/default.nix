{ hostName, ... }:
{
  imports = [
    ./preferences.nix
    ./packages.nix
  ];

  system.stateVersion = 6;

  nix = {
    enable = true;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "kevin"
      ];
    };
  };

  networking = {
    hostName = hostName;
    computerName = hostName;
  };

  users.users.kevin = {
    name = "kevin";
    home = "/Users/kevin";
  };
}
