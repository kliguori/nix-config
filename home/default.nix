{ config, lib, pkgs, ... }:
{
  # Import all program modules (NixOS/Linux only)
  imports = [
   ./modules/git.nix
    ./modules/zsh.nix
    ./modules/starship.nix
    ./modules/kitty.nix
    # ./modules/neovim.nix
    ./programs/nixvim
    ./modules/wofi.nix
    ./modules/ashell.nix
    ./modules/hyprland
  ];

  # Theme options used by multiple modules
  options.theme = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "dracula";
      description = "Theme name";
    };

    colors = lib.mkOption {
      type = lib.types.attrs;
      description = "Color palette";
    };

    fonts = {
      mono = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "Monospace font";
      };

      ui = lib.mkOption {
        type = lib.types.str;
        default = "JetBrainsMono Nerd Font";
        description = "UI font";
      };

      size = lib.mkOption {
        type = lib.types.int;
        default = 12;
        description = "Base font size in px";
      };
    };
  };

  config = {
    # Dracula theme
    theme = {
      name = "dracula";
      colors = {
        background = "#282a36";
        foreground = "#f8f8f2";
        selection = "#44475a";
        comment = "#6272a4";

        cyan = "#8be9fd";
        green = "#50fa7b";
        orange = "#ffb86c";
        pink = "#ff79c6";
        purple = "#bd93f9";
        red = "#ff5555";
        yellow = "#f1fa8c";

        currentLine = "#44475a";

        # RGB versions (without #) for Hyprland
        bgRgb = "282a36";
        fgRgb = "f8f8f2";
        selectionRgb = "44475a";
        commentRgb = "6272a4";
        cyanRgb = "8be9fd";
        greenRgb = "50fa7b";
        orangeRgb = "ffb86c";
        pinkRgb = "ff79c6";
        purpleRgb = "bd93f9";
        redRgb = "ff5555";
        yellowRgb = "f1fa8c";
      };
    };

    programs.home-manager.enable = true;

    home = {
      homeDirectory = "/home/kevin";
      stateVersion = "25.11";

      packages = with pkgs; [
        brave
        spotify
        nerd-fonts.jetbrains-mono

        # Language servers and formatters
        nixd
        nixfmt
        pyright
        black
        ruff
        julia-bin
        clang-tools
        texlab

        # Clipboard
        wl-clipboard
        xclip
      ];
    };
  };
}
