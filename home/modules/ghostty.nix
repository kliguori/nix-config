{ config, pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;

    settings = {
      # Auto update 
      auto-update = "off";
      
      # Set term 
      term = "xterm-256color";

      # Font configuration
      font-family = "JetBrains Mono";
      font-size = 14;
      font-thicken = true;
      
      # Theme and colors
      theme = "dracula";
      background-opacity = 0.95;
      
      # Window appearance (cross-platform)
      window-decoration = true;
      window-padding-x = 8;
      window-padding-y = 8;
      
      # Cursor
      cursor-style = "block";
      cursor-style-blink = false;
      
      # Shell integration
      shell-integration = "detect";
      shell-integration-features = "cursor,sudo,title";
      
      # Keybindings (Linux)
      keybind = [
        "ctrl+shift+n=new_window"
        "ctrl+shift+t=new_tab"
        "ctrl+shift+w=close_surface"
        "ctrl+page_up=previous_tab"
        "ctrl+page_down=next_tab"
        "ctrl+equal=increase_font_size:1"
        "ctrl+minus=decrease_font_size:1"
        "ctrl+0=reset_font_size"
        "ctrl+shift+c=copy_to_clipboard"
        "ctrl+shift+v=paste_from_clipboard"
      ];
      
      # Misc
      confirm-close-surface = false;
      quit-after-last-window-closed = true;
      copy-on-select = false;
      clipboard-read = "allow";
      clipboard-write = "allow";
    };
  };
}
