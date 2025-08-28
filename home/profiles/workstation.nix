{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  programs.git.enable = true;
  home.stateVersion = "24.05";
}
