return {
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        signature = {
          auto_open = {
            enabled = false, -- 核心控制：禁止在插入模式打字时自动弹出
          },
        },
      },
    },
  },
}
