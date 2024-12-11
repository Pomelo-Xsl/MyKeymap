#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook true

#include lib/translation.ahk
#Include lib/Functions.ahk
#Include lib/Actions.ahk
#Include lib/KeymapManager.ahk
#Include lib/InputTipWindow.ahk
#Include lib/Utils.ahk

; #WinActivateForce   ; 先关了遇到相关问题再打开试试
; InstallKeybdHook    ; 这个可以重装 keyboard hook, 提高自己的 hook 优先级, 以后可能会用到
; ListLines False     ; 也许能提升一点点性能 ( 别抱期待 ), 当有这个需求时再打开试试
; #Warn All, Off      ; 也许能提升一点点性能 ( 别抱期待 ), 当有这个需求时再打开试试

DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr") ; 多显示器不同缩放比例会导致问题: https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
SetMouseDelay 0                                           ; SendInput 可能会降级为 SendEvent, 此时会有 10ms 的默认 delay
SetWinDelay 0                                             ; 默认会在 activate, maximize, move 等窗口操作后睡眠 100ms
A_MaxHotkeysPerInterval := 256                            ; 默认 70 可能有点低, 即使没有热键死循环也触发警告
SendMode "Event"                                          ; 执行 SendInput 的期间会短暂卸载 Hook, 这时候松开引导键会丢失 up 事件, 所以 Event 模式更适合 MyKeymap
SetKeyDelay 0                                             ; 默认 10 太慢了, https://www.reddit.com/r/AutoHotkey/comments/gd3z4o/possible_unreliable_detection_of_the_keyup_event/
ProcessSetPriority "High"
SetWorkingDir("../")
InitTrayMenu()
InitKeymap()
OnExit(MyKeymapExit)
#include ../data/custom_functions.ahk

InitKeymap()
{
  taskSwitch := TaskSwitchKeymap("e", "d", "s", "f", "c", "space")
  mouseTip := InputTipWindow("🐶",,,, 20, 16)
  slow := MouseKeymap("slow mouse", false, mouseTip, 2, 2, "T0.13", "T0.01", 1, "T0.2", "T0.03")
  fast := MouseKeymap("fast mouse", false, mouseTip, 15, 15, "T0.13", "T0.01", 1, "T0.2", "T0.03", slow)
  slow.Map("*space", slow.LButtonUp())

  semiHook := InputHook("", "{CapsLock}{Esc}{;}", "dk,exit,fy,gg,jt,kmset,kmwd,pwsh,sj,sk,top,wcq,wgj,wkp,wrex,wsm,wsp,xk,zk")
  semiHook.KeyOpt("{CapsLock}", "S")
  semiHook.KeyOpt("{Backspace}", "N")
  semiHook.OnChar := (ih, char) => semiHookAbbrWindow.Show(char, true)
  semiHook.OnKeyDown := (ih, vk, sc) => semiHookAbbrWindow.Backspace()
  semiHookAbbrWindow := InputTipWindow()


  ; 路径变量
  programs := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\"

  ; 窗口组
  GroupAdd("MY_WINDOW_GROUP_1", "ahk_exe chrome.exe")
  GroupAdd("MY_WINDOW_GROUP_1", "ahk_exe msedge.exe")
  GroupAdd("MY_WINDOW_GROUP_1", "ahk_exe firefox.exe")

  KeymapManager.GlobalKeymap.DisabledAt := ""

  ; 分号模式
  km13 := KeymapManager.NewKeymap(";", "分号模式", "")
  km := km13
  km.Map("*a", _ => (Send("{text}*")))
  km.Map("*b", _ => (Send("{text}%")))
  km.Map("*c", _ => (Send("{text}.")))
  km.Map("*d", _ => (Send("{text}=")))
  km.Map("*e", _ => (Send("{text}^")))
  km.Map("*f", _ => (Send("{text}>")))
  km.Map("*g", _ => (Send("{text}!")))
  km.Map("*h", _ => (Send("{text}+")))
  km.Map("*i", _ => (Send("{text}:")))
  km.Map("*k", _ => (Send("{text}``")))
  km.Map("*m", _ => (Send("{text}-")))
  km.Map("*n", _ => (Send("{text}/")))
  km.Map("*r", _ => (Send("{text}&")))
  km.Map("*s", _ => (Send("{text}<")))
  km.Map("*t", _ => (Send("{text}~")))
  km.Map("*u", _ => (Send("{text}$")))
  km.Map("*v", _ => (Send("{text}|")))
  km.Map("*w", _ => (Send("{text}#")))
  km.Map("*x", _ => (Send("{text}_")))
  km.Map("*y", _ => (Send("{text}@")))
  km.Map("*z", _ => (Send("{text}\")))
  km.Map("singlePress", _ => EnterSemicolonAbbr(semiHook, semiHookAbbrWindow))

  ; 分号子数字
  km10 := KeymapManager.AddSubKeymap(km13, "f", "分号子数字", "")
  km := km10
  km.RemapKey(",", "2")
  km.RemapKey(".", "3")
  km.RemapKey("i", "8")
  km.RemapKey("j", "4")
  km.RemapKey("k", "5")
  km.RemapKey("l", "6")
  km.RemapKey("m", "1")
  km.RemapKey("o", "9")
  km.RemapKey("u", "7")
  km.RemapKey("space", "0")
  km.Map("singlePress", _ => (Send("{text}>")))
  km.Map("*/", km.ToggleLock)

  ; 分号子Ctrl
  km18 := KeymapManager.AddSubKeymap(km13, "l", "分号子Ctrl", "")
  km := km18
  km.Map("*a", _ => (Send("{blind}^a")))
  km.Map("*b", _ => (Send("{blind}^b")))
  km.Map("*c", _ => (Send("{blind}^c")))
  km.Map("*d", _ => (Send("{blind}^d")))
  km.Map("*f", _ => (Send("{blind}^f")))
  km.Map("*s", _ => (Send("{blind}^s")))
  km.Map("*v", _ => (Send("{blind}^v")))
  km.Map("*x", _ => (Send("{blind}^x")))
  km.Map("*y", _ => (Send("{blind}^y")))
  km.Map("*z", _ => (Send("{blind}^z")))
  km.Map("singlePress", _ => (Send("{text}`"")))

  ; 分号子光标移动
  km19 := KeymapManager.AddSubKeymap(km13, "j", "分号子光标移动", "")
  km := km19
  km.Map("*q", fast.ScrollWheelLeft), slow.Map("*q", slow.ScrollWheelLeft)
  km.Map("*r", fast.ScrollWheelDown), slow.Map("*r", slow.ScrollWheelDown)
  km.Map("*t", fast.ScrollWheelRight), slow.Map("*t", slow.ScrollWheelRight)
  km.Map("*w", fast.ScrollWheelUp), slow.Map("*w", slow.ScrollWheelUp)
  km.Map("*2", _ => (Send("{PGUP}")))
  km.Map("*3", _ => (Send("{PGDN}")))
  km.Map("*backspace", _ => (Send("{enter}")))
  km.Map("singlePress", _ => (Send("{text};")))
  km.RemapKey("a", "home")
  km.Map("*b", _ => (Send("^{backspace}")))
  km.RemapKey("c", "backspace")
  km.RemapKey("d", "down")
  km.RemapKey("e", "up")
  km.RemapKey("f", "right")
  km.RemapKey("g", "end")
  km.Map("*k", _ => HoldDownModifierKey("LShift"))
  km.RemapKey("s", "left")
  km.Map("*v", _ => (Send("{blind}^{right}")))
  km.RemapKey("x", "esc")
  km.Map("*z", _ => (Send("{blind}^{left}")))
  km.Map("*space", _ => (Send("{blind}{enter}")))

  ; 分号Alt
  km20 := KeymapManager.AddSubKeymap(km13, "k", "分号Alt", "")
  km := km20
  km.Map("*a", _ => (Send("{blind}!a")))
  km.Map("*b", _ => (Send("{blind}!b")))
  km.Map("*c", _ => (Send("{blind}!c")))
  km.Map("*d", _ => (Send("{blind}!d")))
  km.Map("*f", _ => (Send("{blind}!f")))
  km.Map("*g", _ => (Send("{blind}!g")))
  km.Map("*r", _ => (Send("{blind}!r")))
  km.Map("*s", _ => (Send("{blind}!s")))
  km.Map("*t", _ => (Send("{blind}!t")))
  km.Map("*w", _ => (Send("{blind}!w")))
  km.Map("*x", _ => (Send("{blind}!x")))
  km.Map("*z", _ => (Send("{blind}!z")))
  km.Map("*space", _ => (Send("{blind}^{tab}")))
  km.Map("singlePress", _ => (Send("{blind}{k}")))
  km.Map("*j", _ => HoldDownModifierKey("LShift"))

  ; 分号子鼠标移动
  km21 := KeymapManager.AddSubKeymap(km13, "h", "分号子鼠标移动", "")
  km := km21
  km.Map("*a", fast.ScrollWheelLeft), slow.Map("*a", slow.ScrollWheelLeft)
  km.Map("*b", fast.LButtonDown()), slow.Map("*b", slow.LButtonDown())
  km.Map("*c", fast.MButton()), slow.Map("*c", slow.MButton())
  km.Map("*d", fast.MoveMouseDown, slow), slow.Map("*d", slow.MoveMouseDown)
  km.Map("*e", fast.MoveMouseUp, slow), slow.Map("*e", slow.MoveMouseUp)
  km.Map("*f", fast.MoveMouseRight, slow), slow.Map("*f", slow.MoveMouseRight)
  km.Map("*g", fast.ScrollWheelRight), slow.Map("*g", slow.ScrollWheelRight)
  km.Map("*r", fast.ScrollWheelDown), slow.Map("*r", slow.ScrollWheelDown)
  km.Map("*s", fast.MoveMouseLeft, slow), slow.Map("*s", slow.MoveMouseLeft)
  km.Map("*v", fast.RButton()), slow.Map("*v", slow.RButton())
  km.Map("*w", fast.ScrollWheelUp), slow.Map("*w", slow.ScrollWheelUp)
  km.Map("*x", fast.LButton()), slow.Map("*x", slow.LButton())
  km.Map("*z", _ => MoveMouseToCaret()), slow.Map("*z", _ => MoveMouseToCaret())
  km.Map("singlePress", _ => (Send("{blind}{h}")))

  ; 自定义热键
  km1 := KeymapManager.NewKeymap("customHotkeys", "自定义热键", "")
  km := km1
  km.Map("!'", _ => MyKeymapReload(), , , , "S")
  km.Map("!+'", _ => MyKeymapToggleSuspend(), , , , "S")


  KeymapManager.GlobalKeymap.Enable()
}

ExecCapslockAbbr(command) {
}

ExecSemicolonAbbr(command) {
  ; 路径变量
  programs := "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\"

  switch command {
    case "dk":
      Send("{text}{}"), Send("{left}")
    case "exit":
      MyKeymapExit()
    case "fy":
      openUrl("https://fanyi.baidu.com/mtpe-individual/multimodal")
    case "gg":
      Send("{text}git add -A; git commit -a -m `"`"; git push origin (git branch --show-current);"), Send("{left 47}")
    case "jt":
      Send("{text}->")
    case "kmset":
      MyKeymapOpenSettings()
    case "kmwd":
      ActivateOrRun("", A_WorkingDir)
    case "pwsh":
      ActivateOrRun("", "pwsh.exe")
    case "sj":
      Send(Format("{}年{}月{}日 {}:{}", A_YYYY, A_MM, A_DD, A_Hour, A_Min))
    case "sk":
      Send("「  」"), Send("{left 2}")
    case "top":
      ToggleWindowTopMost()
    case "wcq":
      SystemReboot()
    case "wgj":
      SystemShutdown()
    case "wkp":
      CloseWindowProcesses()
    case "wrex":
      SystemRestartExplorer()
    case "wsm":
      SystemSleep()
    case "wsp":
      SystemLockScreen()
    case "xk":
      Send("{text}()"), Send("{left}")
    case "zk":
      Send("{text}[]"), Send("{left}")
  }
}

InitTrayMenu() {
  A_TrayMenu.Delete()
  A_TrayMenu.Add(Translation().menu_pause, TrayMenuHandler)
  A_TrayMenu.Add(Translation().menu_exit, TrayMenuHandler)
  A_TrayMenu.Add(Translation().menu_reload, TrayMenuHandler)
  A_TrayMenu.Add(Translation().menu_settings, TrayMenuHandler)
  A_TrayMenu.Add(Translation().menu_window_spy, TrayMenuHandler)
  A_TrayMenu.Default := Translation().menu_pause
  A_TrayMenu.ClickCount := 1

  A_IconTip := "MyKeymap 2.0-beta32 created by 咸鱼阿康"
  TraySetIcon("./bin/icons/logo.ico", , true)
}


#HotIf