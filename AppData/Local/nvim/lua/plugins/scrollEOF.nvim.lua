return {
  "Aasim-A/scrollEOF.nvim",
  event = { "CursorMoved", "WinScrolled" },
  opts = {
    insert_mode = true, -- 确保在 Insert (输入) 模式下也能自动保持边距
    floating = true, -- 允许在浮动窗口中生效
    disabled_filetypes = {
      "snacks_terminal", -- 修复 LazyVim 新版内置终端可能出现的画面闪烁
      "terminal",
    },
  },
}
