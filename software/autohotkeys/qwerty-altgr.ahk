#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\workspaces.ahk
#Include %A_ScriptDir%\utilities.ahk

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




