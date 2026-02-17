{ pkgs, ... }:
{
  home.file.".config/niri/config.kdl".text = ''
    // ~/.config/niri/config.kdl
   
    // Start DMS at startup
    spawn-at-startup "${pkgs.dms-shell}/bin/dms" "run"

    // No client decorations
    prefer-no-csd

    // Screenshots
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // Inputs
    input {
      keyboard { 
        numlock
      }

      touchpad { 
        tap
        natural-scroll
      }

      focus-follows-mouse max-scroll-amount="0%"
    }
    
    // Monitors 
    /-output "eDP-1" {
      mode "1920x1080@120.030"
      scale 2
      transform "normal"
      // position x=... y=...   // only needed with multiple monitors
    }
   
    // Layouts
    layout {
      gaps 8
      center-focused-column "never"
      default-column-width { proportion 0.5 }
    
      focus-ring {
        width 4
        active-color "#7fc8ff"
        inactive-color "#505050"
      }
    
      border { off }
    }
   
   // Window rules
    window-rule {
      match app-id=r#"firefox$"# title="^Picture-in-Picture$"
      open-floating true
    }
    
    window-rule {
      geometry-corner-radius 8
      clip-to-geometry true
    }
   
    // Keybinds
    binds {
      // Core apps
      Alt+Return { spawn "kitty"; }
      Alt+D { spawn "dms" "ipc" "call" "spotlight" "toggle"; }
      Alt+Shift+L { spawn "dms" "ipc" "call" "lock" "lock"; }
    
      // Core actions
      Alt+Q repeat=false { close-window; }
      Alt+O repeat=false { toggle-overview; }
      Alt+? { show-hotkey-overlay; }
    
      // Focus 
      Alt+H { focus-column-left; }
      Alt+J { focus-window-or-workspace-down; }
      Alt+K { focus-window-or-workspace-up; }
      Alt+L { focus-column-right; }
    
      // Move (Alt+Space = grab)
      Alt+Space+H { move-column-left; }
      Alt+Space+J { move-window-down-or-to-workspace-down; }
      Alt+Space+K { move-window-up-or-to-workspace-up; }
      Alt+Space+L { move-column-right; }

      // Recent windows (Alt+Tab)
      Alt+Tab repeat=true { focus-recent-window; }
      Alt+Shift+Tab repeat=true { focus-recent-window-backward; }
    
      // Workspaces 
      Alt+U { focus-workspace-down; }
      Alt+I { focus-workspace-up; }
      Alt+Space+U { move-column-to-workspace-down; }
      Alt+Space+I { move-column-to-workspace-up; }
    
      // Workspaces 
      Alt+1 { focus-workspace 1; }
      Alt+2 { focus-workspace 2; }
      Alt+3 { focus-workspace 3; }
      Alt+4 { focus-workspace 4; }
      Alt+5 { focus-workspace 5; }
      Alt+6 { focus-workspace 6; }
      Alt+7 { focus-workspace 7; }
      Alt+8 { focus-workspace 8; }
      Alt+9 { focus-workspace 9; }
    
      Alt+Space+1 { move-column-to-workspace 1; }
      Alt+Space+2 { move-column-to-workspace 2; }
      Alt+Space+3 { move-column-to-workspace 3; }
      Alt+Space+4 { move-column-to-workspace 4; }
      Alt+Space+5 { move-column-to-workspace 5; }
      Alt+Space+6 { move-column-to-workspace 6; }
      Alt+Space+7 { move-column-to-workspace 7; }
      Alt+Space+8 { move-column-to-workspace 8; }
      Alt+Space+9 { move-column-to-workspace 9; }
    
      // Monitors (Ctrl = global)
      Ctrl+H { focus-monitor-left; }
      Ctrl+L { focus-monitor-right; }
      Ctrl+Space+H { move-column-to-monitor-left; }
      Ctrl+Space+L { move-column-to-monitor-right; }
    
      // Layout / state 
      Alt+R { switch-preset-column-width; }
      Alt+F { maximize-column; }
      Alt+Shift+F { fullscreen-window; }
      Alt+V { toggle-window-floating; }
      Alt+C { center-column; }
    
      // Screenshots
      Print { screenshot; }
      Ctrl+Print { screenshot-screen; }
      Alt+Print { screenshot-window; }
    
      // Audio 
      XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"; }
      XF86AudioMute        allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      XF86AudioMicMute     allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
    
      XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
      XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
      XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
      XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }
    
      // Brightness 
      XF86MonBrightnessUp   allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "increment" "5"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn "dms" "ipc" "call" "brightness" "decrement" "5"; }
    
      // Safety / misc
      Alt+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
      Alt+Shift+P { power-off-monitors; }   
      Ctrl+Alt+Delete { quit; }
    }
  '';
}
