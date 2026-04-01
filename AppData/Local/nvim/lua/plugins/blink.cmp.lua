return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        -- 1. 使用 'enter' 预设
        -- 这会保证 <CR> (回车) 键用于 "accept" (确认补全)
        preset = "enter",

        -- 2. 重写 Tab 键逻辑：实现 "Tab 轮询"
        -- 逻辑顺序：
        --    A. select_next: 如果菜单打开，选择下一项
        --    B. snippet_forward: 如果没菜单但有代码片段，跳转到下一空位
        --    C. fallback: 如果以上都没有，输入制表符(缩进)
        -- 3. 重写 Shift+Tab 逻辑：反向轮询
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      },
    },
  },
}
