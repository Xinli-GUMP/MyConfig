return {
  -- 1. LSP 配置：只保留 Basedpyright，彻底关闭 Ruff LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- 你的主力：Basedpyright (负责类型、诊断、跳转)
        basedpyright = {
          settings = {
            basedpyright = {
              disableOrganizeImports = false, -- 开启这个，让 Basedpyright 提供 organize imports
              analysis = {
                typeCheckingMode = "standard",
              },
            },
          },
        },

        -- 🚫 核心修改：显式禁用 Ruff LSP
        -- 这样 Ruff 根本不会启动，自然不可能给你报任何错！
        -- 这不会影响 conform 调用它进行格式化。
        ruff = { enabled = false },
      },
    },
  },

  -- 2. 格式化配置
  {
    "stevearc/conform.nvim",
    opts = {
      -- 1. 自定义 ruff_fix 的行为
      formatters = {
        ruff_fix = {
          -- 告诉 ruff 在修复时忽略 F401 (未使用的导入)
          -- 如果你想连 "自动排序 import" 也关掉，可以加上 "I001"
          append_args = { "--ignore", "F401" },
        },
      },

      -- 2. 调用配置
      formatters_by_ft = {
        python = { "ruff_format", "ruff_fix" },
      },
    },
  },

  -- 3. 确保 Mason 安装了 Ruff
  -- 因为我们禁用了 LSP，为了防止 Mason 以为 Ruff 没用把它自动卸载了，
  -- 我们需要显式声明 "我要安装 ruff"。
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "ruff",
      },
    },
  },
}
