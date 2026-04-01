return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 告诉 LSP 客户端启用 gdscript 支持
        gdscript = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gdscript = { "gdformat" },
      },
    },
  },
  {
    "habamax/vim-godot",
    event = "VeryLazy",
    config = function()
      -- vim.g.godot_executable = "C:/Path/To/Godot.exe"
    end,
  },
}
