return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- 配置行尾的虚拟文本
        virtual_text = {
          -- 【核心代码】设置显示的最低严重程度
          -- min = vim.diagnostic.severity.ERROR
          -- 意思是：只有 ERROR 及其以上级别才显示文字
          -- 如果你想看 Warning，可以改成 WARN
          severity = { min = vim.diagnostic.severity.ERROR },

          -- 也可以配置只显示前缀图标，不显示文字，彻底清爽
          -- format = function(diagnostic) return string.format("%s", diagnostic.message) end,
        },

        -- 侧边栏图标 (Signs) 保持全部显示，这样你知道哪里有 Warning
        signs = true,
        underline = true,
      },
    },
  },
}
