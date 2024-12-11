; 自定义的函数写在这个文件里,  然后能在 MyKeymap 中调用

; 使用如下写法，来加载当前目录下的其他 AutoHotKey v2 脚本
; #Include ../data/test.ahk

sendSomeChinese() {
  Send("{text}你好中文!")
}

global MouseX := 0
global MouseY := 0
global boxLeft := 0
global boxRight := 0
global boxTop := 0
global boxBottom := 0
global startTime := A_TickCount
global globalScreenWidth := 0
global globalScreenHeight := 0
global globalScreenTop := 0
global globalScreenLeft := 0
global globalWinX := 0
global globalWinY := 0

global mouseMoveSpeed := 0
global mouseTimeOut := 3000

CoordMode "Mouse", "Screen"

MonitorCount := MonitorGetCount()
Loop MonitorCount
{
    MonitorGet A_Index, &L, &T, &R, &B
    ; MonitorGetWorkArea A_Index, &WL, &WT, &WR, &WB

    if (B > globalScreenHeight) {
      globalScreenHeight := B
    }
    if (R > globalScreenWidth) {
      globalScreenWidth := R
    }

    if (T < globalScreenTop) {
      globalScreenTop := T
    }
    if (L < globalScreenLeft) {
      globalScreenLeft := L
    }
}

global MyGui1

MyGui1 := Gui()
MyGui1.Opt("+AlwaysOnTop -Caption +LastFound -DPIScale -Disabled +E0x20 -SysMenu")
MyGui1.BackColor := "5CCFE6" ; #5CCFE6
WinSetTransColor(" 100", MyGui1)
MyGui1.OnEvent("Escape", myGuiHide)
MyGui1.SetFont("cRed s30 bold")
MyGui1.MarginX := 0
MyGui1.MarginY := 0
; global text_gui1 := MyGui1.Add("Text", , "i")

global MyGui2

MyGui2 := Gui()
MyGui2.Opt("+AlwaysOnTop -Caption +LastFound -DPIScale -Disabled +E0x20 -SysMenu")
MyGui2.BackColor := "24AD6D" ; #24AD6D
WinSetTransColor(" 100", MyGui2)
MyGui2.OnEvent("Escape", myGuiHide)
MyGui2.SetFont("cRed s30 bold")
MyGui2.MarginX := 0
MyGui2.MarginY := 0
; global text_gui2 := MyGui2.Add("Text", , "o")

global MyGui3

MyGui3 := Gui()
MyGui3.Opt("+AlwaysOnTop -Caption +LastFound -DPIScale -Disabled +E0x20 -SysMenu")
MyGui3.BackColor := "FFD173" ; #FFD173
WinSetTransColor(" 100", MyGui3)
MyGui3.OnEvent("Escape", myGuiHide)
MyGui3.SetFont("cRed s30 bold")
MyGui3.MarginX := 0
MyGui3.MarginY := 0
; global text_gui3 := MyGui3.Add("Text", , "j")

global MyGui4

MyGui4 := Gui()
MyGui4.Opt("+AlwaysOnTop -Caption +LastFound -DPIScale -Disabled +E0x20 -SysMenu")
MyGui4.BackColor := "FC3C4A" ; #FC3C4A
WinSetTransColor(" 100", MyGui4)
MyGui4.OnEvent("Escape", myGuiHide)
MyGui4.SetFont("cRed s30 bold")
MyGui4.MarginX := 0
MyGui4.MarginY := 0
; global text_gui4 := MyGui4.Add("Text", , "k")

global MyGui

MyGui := Gui()
MyGui.Opt("+AlwaysOnTop -Caption +LastFound -DPIScale -Disabled +E0x20 -SysMenu")
MyGui.BackColor := "FC3C4A" ; #FC3C4A
WinSetTransColor(" 100", MyGui)
MyGui.OnEvent("Escape", myGuiHide)
MyGui.SetFont("cRed s30 bold")
MyGui.MarginX := 0
MyGui.MarginY := 0
; global text_gui4 := MyGui.Add("Text", , "k")



; todo: 绘制窗口来显示区域，来辅助操作
; init为true的时候强制初始化
mouseStartCheck(init := false) {
  global
  MouseGetPos &xpos, &ypos
  if (init || MouseX != xpos  || MouseY != ypos  || A_TickCount - startTime > mouseTimeOut)
  {

    if (init)
    {
      MouseX := -10000000
      MouseY := -10000000 
      myGuiHide()
    }
    else
    {
      ; 中心模式
      ; MouseX := globalScreenWidth / 2 + globalScreenLeft
      ; MouseY := globalScreenHeight / 2 + globalScreenTop

      ; 鼠标模式
      MouseX := xpos
      MouseY := ypos
    }

    boxLeft := globalScreenLeft
    boxTop := globalScreenTop
    boxRight := globalScreenWidth
    boxBottom := globalScreenHeight
    startTime := A_TickCount
  }
}

mouseUp() {
  global
  mouseStartCheck()
  boxBottom := MouseY
  boxRight := MouseX
  ; 设置鼠标的位置
  mouseSmoothMove(Floor((boxRight + boxLeft) / 2), Floor((boxBottom + boxTop) / 2))
} 

mouseDown() {
  global
  mouseStartCheck()
  boxBottom := MouseY
  boxLeft := MouseX
  ; 设置鼠标的位置
  mouseSmoothMove(Floor((boxRight + boxLeft) / 2), Floor((boxBottom + boxTop) / 2))
}

mouseLeft() {
  global
  mouseStartCheck()
  boxTop := MouseY
  boxRight := MouseX
  ; 设置鼠标的位置
  mouseSmoothMove(Floor((boxRight + boxLeft) / 2), Floor((boxBottom + boxTop) / 2))
}

mouseRight() {
  global
  mouseStartCheck()
  boxTop := MouseY
  boxLeft := MouseX
  ; 设置鼠标的位置
  mouseSmoothMove(Floor((boxRight + boxLeft) / 2), Floor((boxBottom + boxTop) / 2))
}

mouseLeftClick() {
  MouseClick "left"
  mouseStartCheck(true)
  ; MyGui.show("x " 0 " y " 0 " w " globalScreenWidth " h " globalScreenHeight)
}

mouseMiddleClick() {
  MouseClick "middle"
  mouseStartCheck(true)
}

mouseRightClick() {
  MouseClick "right"
  mouseStartCheck(true)
}

mouseSmoothMove(newX, newY) {
  global
  ; 到尽头了
  MouseGetPos &xpos, &ypos
  if (newX == xpos && newY == ypos) {
    mouseStartCheck(true)
    return
  }
  MouseX := newX
  MouseY := newY
  MouseMove(newX, newY, mouseMoveSpeed)
  startTime := A_TickCount
  myGuiShow(boxLeft, boxTop, (boxRight - boxLeft), (boxBottom - boxTop))
}

myGuiShow(x, y, w, h)
{
  global
  MyGui1.Show("x" x " y" y " w" MouseX - x " h" MouseY - y)
  ; text_gui1.Move((MouseX - x) / 2, (MouseY - y) / 2)
  MyGui2.Show("x" MouseX " y" y " w" boxRight - MouseX " h" boxBottom - y)
  ; text_gui2.Move((boxRight - MouseX) / 2, (MouseY - y) / 2)
  MyGui3.Show("x" x " y" MouseY " w" MouseX - x " h" boxBottom - MouseY)
  ; text_gui3.Move((MouseX - x) / 2, (boxBottom - MouseY) / 2)
  MyGui4.Show("x" MouseX " y" MouseY " w" boxRight - MouseX " h" boxBottom - MouseY)
  ; text_gui4.Move((boxRight - MouseX) / 2, (boxBottom - MouseY) / 2)
}

myGuiHide(*)
{
  ; MyGui.Hide()
  MyGui1.Hide()
  MyGui2.Hide()
  MyGui3.Hide()
  MyGui4.Hide()
}


openUrl(url)
{
  run url
}

; 参考： https://gist.github.com/volks73/1e889e01ad0a736159a5d56268a300a8
; Change Caps Lock to Control when held down; otherwise, Escape
;
; Originally based on the answer provided in 
; [this](https://superuser.com/questions/581692/remap-caps-lock-in-windows-escape-and-control)
; StackExchange SuperUser question.
;
; A shortcut should be created for this script and placed in the Windows 10
; user's startup folder to automatically enable the feature on boot/startup.
; The user's startup folder can be found using the following steps:
;
; 1. Windows Key+R. The _Run_ dialog will appear.
; 2. Enter the following: `%appdata%\Microsoft\Windows\Start Menu\Programs\Startup`
; 3. Press Enter key. A file explorer dialog will appear.
; 
; Obviously, [AutoHotkey](https://autohotkey.com/) must be installed for this to work.
SetStoreCapslockMode false

; 当按下Alt + CapsLock时，切换大小写模式
!CapsLock::
{
	SetCapsLockState !GetKeyState("CapsLock", "T")
}

*CapsLock::
{
  Send "{LControl down}" ; 按下Ctrl
}

*CapsLock up::
{
  Send "{LControl Up}" ; 松开Ctrl
  
  ; 如果之前的按键是CapsLock，就替换成Escape
  if (A_PriorKey=="CapsLock"){
    if (A_TimeSincePriorHotkey < 1000)
      Suspend "1"
      Send "{Esc}"
      Suspend "0"
  }
}

