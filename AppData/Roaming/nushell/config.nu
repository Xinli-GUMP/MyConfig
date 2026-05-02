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

# 极其优雅的 eza 包装
# Nushell 原生的 ls 返回的是强类型的结构化表格，为了防止习惯冲突并保留 eza 的原生高亮，我们用函数包装
# 注意：在 Nushell 中明确调用外部非内置命令时，推荐使用 `^` 符号 (Escape 符)
def ls [...args] {
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
        kill -f  -q $target_pid
    }
}

# carapace
source $"($nu.cache-dir)/carapace.nu"

