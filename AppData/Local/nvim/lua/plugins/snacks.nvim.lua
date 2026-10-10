return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = {
          -- hidden = true,   -- 包含隐藏文件 (. 开头)
          ignored = true, -- 包含 .gitignore 中被忽略的文件
        },
      },
    },
  },
}
