$env:https_proxy="http://127.0.0.1:7890"
$env:http_proxy="http://127.0.0.1:7890"
$env:LANG = "zh_CN.UTF-8"
$env:EDITOR = "nvim"
$env:VISUAL = "nvim"
# 启动PS Module
Import-Module PSColor
Import-Module CompletionPredictor
Import-Module PSReadLine
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
# Set-PSReadLineOption -PredictionViewStyle ListView

# 每次引擎闲置（命令执行完毕，准备显示提示符）时触发
$null = Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -Action {
	$esc = [char]27
    
	# 任务 1：向 Windows Terminal 汇报当前最新路径 (OSC 9;9)
	$path = $PWD.ProviderPath
	[Console]::Write("$esc]9;9;`"$path`"$esc\")
    
	# 任务 2：强制洗刷光标状态为“闪烁竖线”
	[Console]::Write("$esc[5 q")
}

# 禁用提示音
Set-PSReadLineOption -BellStyle None
# 设置 Vi 模式下的光标样式
set-PSReadLineOption -EditMode Vi

# 2. 定义高性能的底层光标切换逻辑
$Script:OnViModeChange = {
	param([string]$Mode)
	if ($Mode -eq 'Command')
	{
		# `e 是底层 ESC 转义符。1 q 代表闪烁方块
		[Console]::Write("`e[1 q")
	} else
	{
		# 5 q 代表闪烁竖线 (完美还原 Neovim 的 Insert 模式)
		[Console]::Write("`e[5 q")
	}
}
# 3. 绑定事件
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler $Script:OnViModeChange
$null = Register-EngineEvent -SourceIdentifier PowerShell.PreCommand -Action {
	[Console]::Write("`e[5 q")
}

# 用TAB显示补全提示
# 确保只在支持 PSReadLine 的控制台环境中设置快捷键
if ($host.Name -eq 'ConsoleHost')
{
	# Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
	# 将 Ctrl+Space 绑定到菜单补全功能
	Set-PSReadLineKeyHandler -Chord Tab -Function MenuComplete
	# 1. 将 Tab 键绑定到 ForwardWord 功能
	# 当存在灰色历史建议时，此功能会从建议中接受下一个“词”（按空格或标点分隔）。
	# 如果没有历史建议，它仍然会尝试标准的 Tab 自动补全（命令、路径、参数等）。
	Set-PSReadLineKeyHandler -Chord Control+Spacebar -Function ForwardWord
}

# Invoke-RestMethod https://wttr.in/changchun
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\emodipt-extend.omp.json" | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })


# 复制上一条命令输出结果
function cpl
{
	$lastCommand = Get-History -Count 1
	Invoke-Expression $lastCommand.CommandLine | Out-String | Set-Clipboard
}


# 设置颜色值
Set-PSReadLineOption -Colors @{
	"Command"            = "#FFF000" # gold - 命令
	"Parameter"          = '#FF4500' # 温暖的橙红色 - 参数
	"Operator"           = "#89ddff" # 青色 (Cyan) - 操作符 | >
	"Variable"           = "#7dcfff" # 浅蓝 (Light Blue) - 变量 $var
	"String"             = "#9ece6a" # 绿色 (Green) - 字符串 'text'
	"Number"             = "#ff9e64" # 橘红 (Dark Orange) - 数字
	"Type"               = "#2ac3de" # 青色 (Cyan) - 类型 [int]
	"Comment"            = "#565f89" # 灰蓝 (Comment Grey) - 注释
	"Keyword"            = "#bb9af7" # 紫色 (Purple) - 关键字 if/else
	"Member"             = "#73daca" # 蓝绿 (Teal) - 属性 .Length
	"Error"              = "#f7768e" # 红色 (Red) - 错误
	"Selection"          = "#364a82" # 深蓝背景 - 选中区域
	"ContinuationPrompt" = "#565f89" # 灰色 - 多行输入的提示符
	"Default"            = "#ADFF2F" # 前景色 - 默认文字
}



# yazi 配置
function y
{
	$tmp = (New-TemporaryFile).FullName
	yazi $args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path -and $cwd -notlike "sftp*" -and $cwd -notlike "search://*")
	{
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}


# psfzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r' -PSReadlineChordSetLocation 'Ctrl+d'


function fzf
{ fzf.exe --preview 'bat.exe --style=numbers --color=always --line-range :100 {}'
}

# shortcut
function q
{
	exit
}

function ipy
{
	ipython
}


# 1. 移除 PowerShell 自带的 ls 别名 (防止冲突)
if (Test-Path alias:ls)
{ Remove-Item alias:ls
}

function ls
{
	# $args 负责把用户输入的其他参数(如 -a)透传给 eza
	eza.exe --icons --classify --color-scale  --group-directories-first $args
}

function ll
{
	eza.exe --icons --color-scale --classify --group-directories-first --time-style long-iso -l $args
}

# 幂运算
function pow($base, $exp) 
{
	[math]::Pow($base, $exp)
}

# 写入文本进入txt
function phone($text)
{
	# `n 是 PowerShell 中的换行符转义序列
	$lineToAdd = "$text`n"
	Add-Content -Path "C:\temp\手机共享\temp.txt" -Value $lineToAdd
}

# --- 剪贴板同步工具 ---
# 1. 电脑 -> 手机 (c2p)
function c2p
{
	$text = Get-Clipboard
	ssh honor "termux-clipboard-set" $text
	Write-Host "✅ 已发送" -F Green
	Write-Host $text
}

# 2. 手机 -> 电脑 (p2c)
function p2c
{
	$text = ssh honor "termux-clipboard-get"
	Set-Clipboard $text
	Write-Host "✅ 已获取" -F Green
	Write-Host $text
}

function g++
{
	#  使用数组定义参数，避免空格解析问题
	$defaultFlags = @( "-g", "-std=c++23", "-finput-charset=UTF-8", "-fexec-charset=UTF-8")
	& g++.exe @defaultFlags @args
}

function clang++
{
	#  使用数组定义参数，避免空格解析问题
	$defaultFlags = @( "-g", "-std=c++23", "-finput-charset=UTF-8", "-fexec-charset=UTF-8")
	& clang++.exe @defaultFlags @args
}


# 命令别名设置
Set-Alias vi nvim
# Set-Alias pyt python3.14t.exe
Set-Alias fkill Invoke-FuzzyKillProcess
Set-Alias lg lazygit

Import-Module PSCompletions

# argc-completions
# Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
$env:ARGC_COMPLETIONS_ROOT = 'C:\Users\86136\Documents\PowerShell\Scripts\argc-completions'
$env:ARGC_COMPLETIONS_PATH = ($env:ARGC_COMPLETIONS_ROOT + '\completions\windows;' + $env:ARGC_COMPLETIONS_ROOT + '\completions')
$env:PATH = $env:ARGC_COMPLETIONS_ROOT + '\bin' + [IO.Path]::PathSeparator + $env:PATH
# To add completions for only the specified command, modify next line e.g. $argc_scripts = @("cargo", "git")
$argc_scripts = ((Get-ChildItem -File -Path ($env:ARGC_COMPLETIONS_ROOT + '\completions\windows'),($env:ARGC_COMPLETIONS_ROOT + '\completions')) | ForEach-Object { $_.BaseName })
# $argc_scripts = @("rclone", "fd", "rg", "fzf", "eza", "scp")
# argc --argc-completions powershell $argc_scripts | Out-String | Invoke-Expression
$PSCompletions.argc_completions($argc_scripts)


# 放在末尾，在PSC前会有编码问题
# [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::InputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
