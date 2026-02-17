{ unstablePkgs, ... }:
{
  imports = [
    ./options.nix
    ./keymaps.nix
    ./plugins
    ./lsp
  ];

  programs.nixvim = {
    enable = true;
    package = unstablePkgs.neovim;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;

    colorschemes.kanagawa = {
      enable = true;
      settings = {
        transparent = false;
        commentStyle = {
          italic = true;
        };
        keywordStyle = {
          italic = true;
        };
        theme = "wave";
      };
    };

    # All extra Lua config in one place
    extraConfigLua = ''
      -- Telescope file browser keymaps
      local telescope = require("telescope")
      local fb = telescope.extensions.file_browser.file_browser

      vim.keymap.set("n", "<leader>e", function()
        fb({
          cwd = vim.fn.expand("%:p:h"),
          previewer = false,
          initial_mode = "normal",
        })
      end, { desc = "Explorer: file dir" })

      vim.keymap.set("n", "<leader>E", function()
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        local cwd = (git_root ~= nil and git_root ~= "") and git_root or vim.loop.cwd()
        fb({
          cwd = cwd,
          previewer = false,
          initial_mode = "normal",
        })
      end, { desc = "Explorer: project root" })

      vim.keymap.set("n", "-", function()
        fb({
          cwd = vim.loop.cwd(),
          previewer = false,
          initial_mode = "normal",
        })
      end, { desc = "Explorer: cwd" })

      -- Julia LSP
      vim.lsp.config.julials = {
        cmd = { "julia", "--startup-file=no", "--history-file=no", "-e", [[
          using LanguageServer;
          server = LanguageServer.LanguageServerInstance(stdin, stdout, false);
          server.runlinter = true;
          run(server);
        ]] },
        filetypes = { "julia" },
        root_markers = { "Project.toml", ".git" },
      }
      vim.lsp.enable({ "julials" })
    '';
  };
}
