{ ... }:
{
  programs.nixvim.keymaps = [
    # Buffer navigation
    {
      mode = "n";
      key = "<Tab>";
      action = "<cmd>BufferLineCycleNext<CR>";
      options.desc = "Next buffer";
    }
    {
      mode = "n";
      key = "<S-Tab>";
      action = "<cmd>BufferLineCyclePrev<CR>";
      options.desc = "Prev buffer";
    }
    {
      mode = "n";
      key = "<leader>bp";
      action = "<cmd>BufferLinePick<CR>";
      options.desc = "Pick buffer";
    }
    {
      mode = "n";
      key = "<leader>bc";
      action = "<cmd>bdelete<CR>";
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>bo";
      action = "<cmd>BufferLineCloseOthers<CR>";
      options.desc = "Close others";
    }
    {
      mode = "n";
      key = "<leader>b>";
      action = "<cmd>BufferLineMoveNext<CR>";
      options.desc = "Move buffer right";
    }
    {
      mode = "n";
      key = "<leader>b<";
      action = "<cmd>BufferLineMovePrev<CR>";
      options.desc = "Move buffer left";
    }

    # Move lines
    {
      mode = "n";
      key = "<A-j>";
      action = ":m .+1<CR>==";
      options.desc = "Move line down";
    }
    {
      mode = "n";
      key = "<A-k>";
      action = ":m .-2<CR>==";
      options.desc = "Move line up";
    }
    {
      mode = "v";
      key = "<A-j>";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "<A-k>";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move selection up";
    }
  ];
}
