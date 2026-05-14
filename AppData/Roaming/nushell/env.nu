# env.nu
#
# Installed by:
# version = "0.111.0"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

# 注入全局环境变量
$env.https_proxy = "http://127.0.0.1:7890"
$env.http_proxy = "http://127.0.0.1:7890"
$env.LANG = "zh_CN.UTF-8"
$env.EDITOR = "nvim"
$env.VISUAL = "nvim"

# ==========================================
# 修复 Windows 下目录惨遭绿色背景涂毒的 Bug
# ==========================================
# 这里的 38;2;125;207;255 是你的东京之夜青色 (#7dcfff) 的 RGB 转换 ANSI 码
# di = 目录 (Directory)
# ow = 其他人可写目录 (Other Writable)
# st = 粘滞位目录 (Sticky)
$env.LS_COLORS = "di=38;2;125;207;255:ow=38;2;125;207;255:st=38;2;125;207;255"
