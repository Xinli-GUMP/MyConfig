return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      transparent = true,
      styles = {
        sidebars = "dark",
        floats = "dark",
      },
    },
  },
  --
  -- 1. 配置 Everforest 主题
  {
    "sainnhe/everforest",
    lazy = false,
    priority = 1000,
    -- transparent = true,
    config = function()
      -- 风格：hard, medium(默认), soft(推荐)
      vim.g.everforest_background = "hard"

      -- 启用斜体
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_disable_italic_comment = 1

      -- 性能优化
      vim.g.everforest_better_performance = 1
      -- (可选) 如果你想要背景透明，取消注释下面这行
      vim.g.everforest_transparent_background = 2
      vim.g.everforest_sign_column_background = "liner"
      vim.g.everforest_diagnostic_virtual_text = "highlighted"
    end,
  },
  --
  -- {
  --   "catppuccin/nvim",
  --   name = "catppuccin",
  --   priority = 1000,
  --   lazy = false,
  --   opts = {
  --     transparent_background = true,
  --     flavour = "frappe", -- latte, frappe, macchiato, mocha
  --   },
  -- },
  {
    "Mofiqul/vscode.nvim",
    lazy = false, -- 必须设为 false，确保启动时加载
    priority = 1000, -- 优先级设为最高，确保最先加载
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        -- 可选配置
        transparent = true, -- 是否透明背景
        italic_comments = false, -- 注释斜体
        underline_links = true,
        -- Apply theme colors to terminal
        terminal_colors = true,
        -- disable_nvimtree_bg = true, -- 去掉侧边栏背景色

        -- 风格选择: 'dark' (经典), 'light' (浅色), 'dark_modern' (新版默认)
        style = "dark",
      })
    end,
  },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "tokyonight",
      colorscheme = "everforest",
      -- colorscheme = "catppuccin",
      -- colorscheme = "vscode",
    },
  },
}
