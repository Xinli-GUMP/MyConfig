# config.nu
#
# Installed by:
# version = "0.111.0"
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

$env.config.show_banner = false
$env.config.edit_mode = "vi"
# Vi 插入模式 (原本的 ": ") 设为空
$env.PROMPT_INDICATOR_VI_INSERT = {|| "" }
# Vi 普通模式 (原本的 "〉") 设为空
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "" }
$env.config.buffer_editor = "nvim"
# ==========================================
# 强制定义 Nushell 的光标形状
# ==========================================
$env.config.cursor_shape = {
    emacs: line      # 默认模式强制为竖线
    vi_insert: line  # vi 插入模式为竖线
    vi_normal: block # vi 正常模式为方块
}

# 基础别名映射
alias vi = nvim
alias lg = lazygit
alias ipy = ipython
alias q = exit

# 注意：在 Nushell 中明确调用外部非内置命令时，推荐使用 `^` 符号 (Escape 符)
def eza [...args] {
    ^eza --icons --classify --color-scale --group-directories-first ...$args
}

def ll [...args] {
    ^eza --icons --color-scale --classify --group-directories-first --time-style long-iso -l ...$args
}

# 解决 g++ 与 clang++ 的参数透传问题
# 必须使用加引号的 "g++" 来定义包含特殊字符的函数名
def "g++" [...args] {
    ^g++ -g -std=c++23 -finput-charset=UTF-8 -fexec-charset=UTF-8 ...$args
}

def "clang++" [...args] {
    ^clang++ -g -std=c++23 -finput-charset=UTF-8 -fexec-charset=UTF-8 ...$args
}

# yazi
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	^yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != $env.PWD and ($cwd | path exists) {
		cd $cwd
	}
	rm -fp $tmp
}

def fzf [...args] {
    ^fzf --preview 'bat --style=numbers --color=always --line-range :100 {}' ...$args
}

# ==========================================
# fzf 快捷键绑定 (Ctrl+R / Ctrl+T / Ctrl+D)
# ==========================================
$env.config.keybindings = ($env.config.keybindings | append [
    {
        name: fzf_history
        modifier: control
        keycode: char_r
        mode: [emacs, vi_insert, vi_normal]
        event: {
            send: executehostcommand
            # 底层逻辑：读取历史 -> 翻转 -> 去重 -> 传给 fzf -> 如果未取消，则替换当前命令行输入
            # complete 命令用于优雅地捕获 fzf 被 ESC 取消时的异常退出码，防止满屏红字报错
            cmd: "let out = (history | get command | reverse | uniq | str join (char nl) | ^fzf --no-sort --layout=reverse --height=40% | complete); if $out.exit_code == 0 { commandline edit --replace ($out.stdout | str trim) }"
        }
    },
    {
        name: fzf_file_search
        modifier: control
        keycode: char_t
        mode: [emacs, vi_insert, vi_normal]
        event: {
            send: executehostcommand
            # 搜索文件 -> 插入到当前光标位置
            cmd: "let out = (^fzf --layout=reverse --height=40% | complete); if $out.exit_code == 0 { commandline edit --insert ($out.stdout | str trim) }"
        }
    },
    {
        name: fzf_cd
        modifier: control
        keycode: char_d
        mode: [emacs, vi_insert, vi_normal]
        event: {
            send: executehostcommand
            # 搜索并切换目录。注意：这会覆盖 Nushell 默认的 Ctrl+D (退出终端) 行为。
            # 如果你的 fzf 版本较新 (>=0.48)，推荐加上 --walker=dir 只搜索文件夹
            cmd: "let out = (^fzf --walker=dir --layout=reverse --height=40% | complete); if $out.exit_code == 0 { cd ($out.stdout | str trim) }"
        }
    }
])

def fkill [] {
    # 1. 用 ps 提取关键字段，转为 TSV 格式，通过管道喂给 fzf
    # --header-lines=1 会极其聪明地把表头固定在最上方
    let out = (ps | select pid name cpu mem | to tsv | ^fzf --layout=reverse --header-lines=1 | complete)
    
    # 2. 如果你在 fzf 中按回车选中了进程 (exit_code == 0)
    if $out.exit_code == 0 {
        # 提取第一列的 PID，转为整数并物理消灭
        let target_pid = ($out.stdout | split row "\t" | first | str trim | into int)
        kill -f -q $target_pid
    }
}

# 开启全局模糊匹配 (Fuzzy)
$env.config.completions.algorithm = "fuzzy"
# carapace
source $"($nu.cache-dir)/carapace.nu"

# ==========================================
# 注入定制语法高亮 (Tokyo Night 风格)
# ==========================================
$env.config.color_config = ($env.config.color_config | default {} | merge {
    # 基础类型
    shape_garbage: "#f7768e"          # 错误 (Error) - 红色
    shape_string: "#9ece6a"           # 字符串 (String) - 绿色
    shape_string_interpolation: "#2ac3de" # 包含变量的字符串
    shape_int: "#ff9e64"              # 整数 - 橘红
    shape_float: "#ff9e64"            # 浮点数 - 橘红
    shape_variable: "#7dcfff"         # 变量 (Variable) - 浅蓝
    shape_literal: "#ADFF2F"          # 默认前景色

    # 命令与关键字
    shape_internalcall: "#FFF000"     # 内部命令 - 金色
    shape_external: "#FFF000"         # 外部命令 - 金色
    shape_external_resolved: "#FFF000" # 已解析的外部命令 - 金色 (注意这里的完美空格)
    shape_keyword: "#bb9af7"          # 关键字 (Keyword) - 紫色
    
    # 参数与操作符
    shape_flag: "#FF4500"             # 参数 (Parameter) - 橙红
# shape_externalarg: "#a9b1d6" # 外部命令的参数 - 东京之夜的淡蓝灰色
    shape_operator: "#89ddff"         # 操作符 (Operator) - 青色
    shape_pipe: "#89ddff"             # 管道符 |
    shape_redirection: "#89ddff"      # 重定向 >

    # 路径与成员访问
    cell_path: "#73daca"              # 属性成员 (Member) - 蓝绿
    shape_filepath: "#7dcfff"         # 文件路径
    shape_directory: "#7dcfff"        # 目录
    shape_globpattern: "#2ac3de"      # 通配符 (*, ?)

    # 类型与注释
    shape_signature: "#2ac3de"        # 类型签名 (Type) - 青色
    shape_comment: "#565f89"          # 注释 (Comment) - 灰蓝
})

# ==========================================
# 交换 Tab 和 Ctrl+Space 的触发菜单
# ==========================================
$env.config.keybindings = ($env.config.keybindings | append [
    # 1. 把 Tab 键的灵魂献给 IDE 菜单
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
    # 2. 把 Ctrl+Space 降级为触发传统的网格菜单
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

