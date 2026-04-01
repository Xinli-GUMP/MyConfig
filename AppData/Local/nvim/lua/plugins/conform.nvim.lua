return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- 核心配置：告诉 conform，toml 文件用 taplo 格式化
        toml = { "taplo" },
      },
    },
  },
}
