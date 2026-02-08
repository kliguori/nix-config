{
  pkgs,
  hostName,
  ...
}:
{
  # System state version
  system.stateVersion = 6;

  # Nix settings
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

  # Hostname
  networking = {
    hostName = hostName;
    computerName = hostName;
  };

  # User
  users.users.kevin = {
    name = "kevin";
    home = "/Users/kevin";
  };

  # Basic packages
  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  # Enable zsh
  programs.zsh.enable = true;
}
