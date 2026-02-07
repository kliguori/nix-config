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

      # Kanagawa colors
      layer = "top";
      background-color = c.background;
      color = c.foreground;

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

      "hyprland/window" = {
        max-length = 50;
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
        format-charging = "{capacity}% ";
        format-warning = "{capacity}% ";
        format-critical = "{capacity}% ";
      };

      network = {
        format-wifi = "{essid} ";
        format-ethernet = "{ipaddr} ";
        format-disconnected = "Disconnected ⚠";
      };

      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = " muted";
        format-icons = {
          default = [
            ""
            ""
            ""
          ];
        };
      };
    };

    # Custom CSS styling with Kanagawa colors
    style = ''
      * {
        font-family: ${config.theme.fonts.mono};
        font-size: ${toString config.theme.fonts.size}px;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background-color: ${c.background};
        color: ${c.foreground};
      }

      #workspaces button {
        padding: 0 8px;
        color: ${c.comment};
        background-color: transparent;
      }

      #workspaces button.active {
        color: ${c.foreground};
        background-color: ${c.purple};
      }

      #workspaces button:hover {
        background-color: ${c.selection};
        color: ${c.foreground};
      }

      #window,
      #clock,
      #battery,
      #network,
      #pulseaudio {
        padding: 0 10px;
        margin: 0 2px;
        background-color: ${c.currentLine};
        color: ${c.foreground};
      }

      #battery.charging {
        color: ${c.green};
      }

      #battery.warning {
        color: ${c.yellow};
      }

      #battery.critical {
        color: ${c.red};
        animation: blink 1s linear infinite;
      }

      @keyframes blink {
        to {
          color: ${c.background};
          background-color: ${c.red};
        }
      }

      #network.disconnected {
        color: ${c.comment};
      }

      #pulseaudio.muted {
        color: ${c.comment};
      }

      #tray {
        padding: 0 10px;
        background-color: ${c.currentLine};
      }
    '';
  };
}
