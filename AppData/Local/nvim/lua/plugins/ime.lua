return {
  {
    "brglng/vim-im-select",
    lazy = false, -- 强烈建议关闭懒加载，确保从启动那一刻起就接管输入法
    config = function()
      -- 【核心配置】：告诉插件你的“英文输入法 ID”是多少。
      -- Windows 下美式键盘标准 ID 是 1033。
      vim.g.im_select_default = "1033"
    end,
  },
}
