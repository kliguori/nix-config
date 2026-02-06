{ config, pkgs, ... }:

{
  programs.ashell = {
    enable = true;
    settings = {
      position = "top";  # or "bottom"
      height = 30;
      
      modules-left = [
        "hyprland/workspaces"
        "hyprland/window"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "network"
        "pulseaudio"
        "battery"
        "tray"
      ];
      
      "hyprland/workspaces" = {
        format = "{name}";
        on-click = "activate";
      };
      
      clock = {
        format = "{:%H:%M}";
        tooltip-format = "{:%Y-%m-%d}";
      };
      
      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
      };
      
      network = {
        format-wifi = "{essid} ";
        format-ethernet = "{ipaddr} ";
        format-disconnected = "Disconnected ⚠";
      };
      
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = " muted";
      };
    };
  };
}
