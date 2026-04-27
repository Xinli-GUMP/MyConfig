; Requires AutoHotkey v2.0
; # -> Win | ! -> alt | ^ -> ctrl | + -> | shift

; 设置快捷键 Win + E 运行 yazi

#e::
{
    ; 1. 启动命令
    Run "wt -w 0 new-tab -d E:\Downloads yazi"
    
    ; 2. 强力探测：首先等待窗口【存在】（解决异步启动问题）
    ; 设置 2 秒超时，防止死循环
    if WinWait("ahk_exe WindowsTerminal.exe", , 2)
    {
        ; 3. 发出激活指令
        WinActivate "ahk_exe WindowsTerminal.exe"
        
        ; 4. 关键：等待窗口真正变为【活动状态】（解决焦点被抢占问题）
        ; 如果在 1 秒内没激活成功，可以尝试再激活一次
        if !WinWaitActive("ahk_exe WindowsTerminal.exe", , 1)
        {
            WinActivate "ahk_exe WindowsTerminal.exe"
        }
    }
}


; #e::
; {
;      Run "wt -w 0 new-tab -d E:\Downloads yazi"
;     ; 等待一段时间以确保新标签页已经打开
;     Sleep 200
;     ; 激活 Windows Terminal 窗口
;     if WinExist("ahk_exe WindowsTerminal.exe")
;     {
;         WinActivate
;     }
;     return
; }

; 设置快捷键 Win + alt + E 运行 yazi
 ; #!e::
 ; {
 ;   Run "wt -w 0 new-tab -d E:\Downloads yazi"
 ; }


; 方向键映射
#HotIf WinActive("ahk_class Chrome_WidgetWin_1") or WinActive("ahk_class MozillaWindowClass") or WinActive("ahk_exe goldendict.exe") or WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe explorer.exe") or WinActive("ahk_exe Everything.exe") or WinActive("ahk_exe Weixin.exe") or WinActive("ahk_exe WINWORD.EXE") or WinActive("ahk_exe Wox.exe") or WinActive("ahk_class Notepad") or WinActive("ahk_exe DB Browser for SQLite.exe") or WinActive("ahk_exe ArcGISPro.exe")
    !c::Click() ; alt+c
    !h::Send("{Left}")
    !j::Send("{Down}")
    !k::Send("{Up}")
    !l::Send("{Right}")
#HotIf


; 按 Alt+数字键7 置顶
!Numpad7:: {
    hWnd := WinGetID("A")
    ExStyle := DllCall("GetWindowLong", "Ptr", hWnd, "Int", -20, "UInt")
    if (ExStyle & 0x8)  ; 检查 WS_EX_TOPMOST 位
        WinSetAlwaysOnTop(false, "A")
    else
        WinSetAlwaysOnTop(true, "A")
}


; 按下 Alt+F11 键来调整当前活动窗口的透明度
!F11:: {
    hwnd := WinExist("A") 
    ; 获得当前窗口ID，使用WinExist而不是WinGetID
    if (!hwnd)
    {
        MsgBox("窗口句柄获取失败")
        return
    }

    ; 获得当前窗口透明值,确保透明度在0到255的范围内
    T := WinGetTransparent(hwnd)     

    ; 如果没有获取到透明度，初始化透明度为255
    if (T == "" or T == "ERROR")
    {
        T := 255    ; 如果透明度为空或者透明度小于195，则重置透明度

    }
    if (T = "" or T < 195) 
    {
        T := 255
        WinSetTransparent(T, hwnd)
        return
    }
    T := T - 15 ; 每次透明度减少15
    WinSetTransparent(T, hwnd)
}
