# config.nu
#
# Installed by:
# version = "0.114.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

use std/dirs
use uv.nu *
use himalaya.nu *

# ==========================================
# 1. 基础环境变量与提示符微调
# ==========================================
$env.TRANSIENT_PROMPT_COMMAND = {|| "❯ " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "" }

# ==========================================
# 2. 核心 Config 基础项打底
# ==========================================
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.buffer_editor = "nvim"
$env.config.completions.algorithm = "fuzzy"

$env.config.cursor_shape = {
    emacs: line      # 默认模式强制为竖线
    vi_insert: line  # vi 插入模式为竖线
    vi_normal: block # vi 正常模式为方块
}


# ==========================================
# 4. 基础别名映射 (Alias)
# ==========================================
alias dir = ls
alias vi = nvim
alias lg = lazygit
alias ipy = ipython
# alias q = exit
alias g++ = ^g++ -g -std=c++23 -finput-charset=UTF-8 -fexec-charset=UTF-8
alias clang++ = ^clang++ -g -std=c++23 -fuse-ld=lld -finput-charset=UTF-8 -fexec-charset=UTF-8
alias ls = ^eza --icons --classify --color-scale --group-directories-first
alias ll = ^eza --icons --color-scale --classify --group-directories-first --time-style long-iso -l

# yazi
def --env y [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    ^yazi ...$args --cwd-file $tmp
    let cwd = (open $tmp)
    if $cwd != $env.PWD and ($cwd | path exists) {
        cd $cwd
    }
    rm -fp $tmp
    # print -n "\e[?1049l\e[2J\e[H"
}

# fzf 预览流
def fzf [...args] {
    ^fzf -m --preview 'bat --style=numbers --color=always --line-range :100 {}' ...$args
}

# 模糊进程kill
def fkill [] {
    # 1. 构造固定列宽的对齐表头
    let header = $"("pid" | fill -w 8) ("name" | fill -w 30) ("cpu(%)" | fill -w 8 -a right)   ("mem" | fill -w 10 -a right)"

    # 2. 对数据进行格式化与定宽填充
    let rows = (
        ps
        | sort-by -r cpu mem
        | update cpu { math round --precision 1 }
        | each { |row|
            let pid  = ($row.pid | into string | fill -w 8)
            let name = ($row.name | into string | fill -w 30)
            let cpu  = ($row.cpu | into string | fill -w 8 -a right)
            let mem  = ($row.mem | into string | fill -w 10 -a right)
            $"($pid) ($name) ($cpu)   ($mem)"
        }
    )

    let input_text = ([$header] | append $rows | str join (char newline))

    # 3. 送入 fzf 交互
    let out = (
        $input_text
        | ^fzf -m --layout=reverse --header-lines=1 --prompt="Fkill > "
        | complete
    )

    # 4. 解析选中的 PID 并批量强杀
    if $out.exit_code == 0 and ($out.stdout | str trim | is-not-empty) {
        let target_pids = (
            $out.stdout
            | lines
            | each { |line|
                # 按连续空格拆分，提取第一列 PID
                $line | split row " " | where { not ($in | is-empty) } | first | into int
            }
        )
        kill -f -q ...$target_pids
    }
}

# 剪贴板跨端共享 (电脑 -> 手机)
def c2p [] {
    let text = (^cb p | str trim)
    if ($text | is-empty) {
        print $"(ansi red_bold)❌ 错误: 电脑剪贴板当前为空，取消发送(ansi reset)"
        return
    }
    ^ssh honor "termux-clipboard-set" $text
    print $text
}

# 剪贴板跨端共享 (手机 -> 电脑)
def p2c [] {
    let text = (^ssh honor "termux-clipboard-get" | str trim)
    if ($text | is-empty) {
        print $"(ansi red_bold)❌ 错误: 手机剪贴板为空，未获取到任何数据(ansi reset)"
        return
    }
    $text | ^cb
    print $text
}

# 天气
def weather [city: string = fengcheng] {
   curl wttr.in/($city)?lang=zh
}

# ==========================================
# 7. 交换 Tab 和 Ctrl+Space 的菜单触发逻辑
# ==========================================
$env.config.keybindings = ($env.config.keybindings | append [
    {
        name: trigger_ide_menu
        modifier: none
        keycode: tab
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                { send: menu name: ide_completion_menu }
                { send: menunext }
                { edit: complete }
            ]
        }
    },
    {
        name: trigger_classic_menu
        modifier: control
        keycode: space
        mode: [emacs, vi_normal, vi_insert]
        event: {
            until: [
                { send: menu name: completion_menu }
                { send: menunext }
                { edit: complete }
            ]
        }
    }
])

# ==========================================
# 8. 注入定制语法高亮 (Tokyo Night 风格)
# ==========================================
$env.config.color_config = ($env.config.color_config | default {} | merge {
    shape_garbage: "#f7768e"          # 错误 (Error) - 红色
    shape_string: "#9ece6a"           # 字符串 (String) - 绿色
    shape_string_interpolation: "#2ac3de" # 包含变量的字符串
    shape_int: "#ff9e64"              # 整数 - 橘红
    shape_float: "#ff9e64"            # 浮点数 - 橘红
    shape_variable: "#7dcfff"         # 变量 (Variable) - 浅蓝
    shape_literal: "#ADFF2F"          # 默认前景色

    shape_internalcall: "#FFF000"     # 内部命令 - 金色
    shape_external: "#FFF000"         # 外部命令 - 金色
    shape_external_resolved: "#FFF000" # 已解析的外部命令 - 金色
    shape_keyword: "#bb9af7"          # 关键字 (Keyword) - 紫色
    
    shape_flag: "#FF4500"             # 参数 (Parameter) - 橙红
    shape_operator: "#89ddff"         # 操作符 (Operator) - 青色
    shape_pipe: "#89ddff"             # 管道符 |
    shape_redirection: "#89ddff"      # 重定向 >

    cell_path: "#73daca"              # 属性成员 (Member) - 蓝绿
    shape_filepath: "#7dcfff"         # 文件路径
    shape_directory: "#7dcfff"        # 目录
    shape_globpattern: "#2ac3de"      # 通配符 (*, ?)

    shape_signature: "#2ac3de"        # 类型签名 (Type) - 青色
    shape_comment: "#565f89"          # 注释 (Comment) - 灰蓝
})

# ==========================================
# 9. 外部动态补全注入 (Carapace)
# ==========================================
source $"($nu.cache-dir)/carapace.nu"
$env.CARAPACE_MATCH = "CASE_INSENSITIVE"
