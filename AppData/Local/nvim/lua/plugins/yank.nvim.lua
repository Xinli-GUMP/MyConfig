return {
  {
    "gbprod/yanky.nvim",
    dependencies = {
      -- (可选) 使用 sqlite 存储历史记录，比默认的 Shada 更持久、性能更好
      -- 如果你在 Windows 上配置 sqlite 麻烦，可以注释掉这行，Yanky 会自动降级使用 Shada
      -- { "kkharji/sqlite.lua" },
    },
    opts = {
      -- 1. 核心环形存储配置
      ring = {
        history_length = 50, -- 记住最近 50 次复制
        storage = "shada", -- 默认使用 Neovim 自带存储 (如果装了 sqlite 可改为 "sqlite")
        sync_with_numbered_registers = true, -- 将历史同步到 "1-"9 寄存器
        cancel_event = "update",
      },

      -- 2. 高亮配置 (视觉反馈)
      highlight = {
        on_put = true, -- 粘贴后高亮文本
        on_yank = true, -- 复制后高亮文本
        timer = 200, -- 高亮持续 200ms
      },

      -- 3. 光标位置保护
      preserve_cursor_position = {
        enabled = true, -- 复制时，光标保持在原位（原生 Vim 会跳到开头）
      },
    },

    -- 4. 按键映射 (这是 Yanky 的灵魂)
    keys = {
      -- [基础粘贴] 劫持原生的 p 和 P
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },

      -- [历史轮询] 粘贴后按 Ctrl+p / Ctrl+n 切换剪贴板历史
      { "<C-p>", "<Plug>(YankyPreviousEntry)", desc = "Select previous entry through yank history" },
      { "<C-n>", "<Plug>(YankyNextEntry)", desc = "Select next entry through yank history" },

      -- [特殊粘贴] Python/C++ 开发者神器：智能缩进粘贴
      -- 在函数体内粘贴代码时，自动调整缩进，不再需要手动调整
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },

      -- [过滤器粘贴] 类似 =p，粘贴并自动格式化
      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
  },
}
