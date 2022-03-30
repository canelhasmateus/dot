#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\lib\workspaces.ahk
#Include %A_ScriptDir%\lib\random.ahk
#Include %A_ScriptDir%\lib\accData.ahk

GetNextKey() 
{
  Input pressedKey, M L1 T2 B, {Escape}{Tab}{Backspace}
  return pressedKey
}

sendDesktopOrSwitchDesktop( desktopNumber ) 
{
  if GetKeyState("LAlt", "P") = 1
  {
    
    ; Todo: Send current window to another desktop.
  
  }
  else
  {
    switchDesktopByNumber( desktopNumber)
  }

}

<^>!SC01E:: 
  {
    Send {\}
    return
  }

<^>!SC01F:: 
  {
    Send {|}
    return
  }



<^>!SC018::
  {
    pressedKey := GetNextKey()
    
    if pressedKey is number
    {
      sendDesktopOrSwitchDesktop( pressedKey )
    }
    else if (pressedkey = "r")
    {
      switchDesktopToLastOpened()
    }
    else if ( pressedKey = "f")
    {
      OpenHighlighted()
    }
    
    return
  } 


*F8:: ; using Hotkey with asterisk so Ctrl+Hotkey will reset Obj history
    st:= A_TickCount
    accData:= GetAccData() ; parameter: "A" (default), "WinTitle", "ahk_class IEFrame", "ahk_exe chrome.exe", etc.
    MsgBox % A_TickCount-st "`n`n" accData.1 "`n`n" accData.2
Return


