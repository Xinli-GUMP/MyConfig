return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      -- 确保 sections 表存在
      opts.sections = opts.sections or {}
      opts.sections.lualine_y = opts.sections.lualine_y or {}
      -- 暴力重置 lualine_y，确保我们的设置生效
      -- 顺序：编码 | 格式 | 进度百分比
      opts.sections.lualine_y = { "encoding", "fileformat", "progress" }
      -- opts.theme = "vscode"
    end,
  },
}
