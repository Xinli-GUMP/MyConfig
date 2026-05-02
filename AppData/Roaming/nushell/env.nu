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

