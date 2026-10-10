return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      indent = {
        enable = true,
        -- 【核心修复】：在这里把 cpp 和 c 加进禁用列表
        disable = { "cpp", "c", "godot", "lua" },
      },
    },
  },
}
