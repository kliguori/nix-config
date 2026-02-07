{ config, pkgs, ... }:
let
  c = config.theme.colors;
in
{
  programs.ashell = {
    enable = true;
    settings = {
      position = "top";
      height = 30;
      
      # Theming
      theme = {
        background = c.background;
        foreground = c.foreground;
        selection = c.selection;
        primary = c.purple;
        success = c.green;
        warning = c.yellow;
        error = c.red;
        info = c.cyan;
      };
      
      modules-left = [
        "settings"
        "workspaces"
      ];
      modules-center = [
        "window-title"
      ];
      modules-right = [
        "media-player"
        "system-info"
        "tray"
        "clock"
      ];
      
      # Workspaces
      workspaces = {
        format = "{name}";
        on-click = "activate";
      };
      
      # Window Title
      window-title = {
        max-length = 50;
      };
      
      # Clock
      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%Y-%m-%d}";
      };
      
      # Media Player
      media-player = {
        format = "{artist} - {title}";
        format-paused = " {artist} - {title}";
      };
      
      # System Info
      system-info = {
        format = "  {cpu}%   {memory}%";
        interval = 5;
      };
      
      # Tray
      tray = {
        icon-size = 16;
        spacing = 10;
      };
      
      # Settings
      settings = {
        # Settings module configuration
      };
    };
  };
}
