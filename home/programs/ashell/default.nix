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
        "workspaces"
      ];
      modules-center = [
        "window-title"
      ];
      modules-right = [
        "media-player"
        "system-info"
        "tray"
        "settings"
        "clock"
      ];
      
      # Workspaces Configuration
      workspaces = {
        visibility_mode = "All";
        enable_workspace_filling = true;
        max_workspaces = 10;
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
      
      # System Info - Configure indicators
      system-info = {
        indicators = [ "Cpu" "Memory" "Temperature" ];
      };
      
      # System Info Thresholds
      "system-info.cpu" = {
        warn_threshold = 60;
        alert_threshold = 80;
      };
      
      "system-info.memory" = {
        warn_threshold = 70;
        alert_threshold = 85;
      };
      
      "system-info.temperature" = {
        warn_threshold = 60;
        alert_threshold = 80;
        sensor = "acpitz temp1";
      };
      
      # Tray
      tray = {
        icon-size = 16;
        spacing = 10;
      };
      
      # Settings Module
      settings = {
        lock_cmd = "hyprlock &";
        shutdown_cmd = "shutdown now";
        suspend_cmd = "systemctl suspend";
        reboot_cmd = "systemctl reboot";
        logout_cmd = "loginctl kill-user $(whoami)";
      };
    };
  };
}
