{
  pkgs,
  hostName,
  ...
}:
{
  # System state version
  system.stateVersion = 6;

  # Nix settings
  nix.settings = {
    experimental-features = "nix-command flakes";
    trusted-users = [
      "root"
      "kevin"
    ];
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

  # Enable nix-daemon
  services.nix-daemon.enable = true;

  # Enable zsh
  programs.zsh.enable = true;
}
