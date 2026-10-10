return {
  {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      -- include a picker of your choice, see picker section for more details
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      cn = {
        -- leetcode.cn
        enabled = true, ---@type boolean
        translator = false, ---@type boolean
        translate_problems = true, ---@type boolean
      },
      -- default language
      lang = "cpp",
      storage = {
        home = "E:/Documents/C++/LeetCode",
      },
    },
  },
}
