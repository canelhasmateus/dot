#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\lib\workspaces.ahk
#Include %A_ScriptDir%\lib\Gnosis.ahk
#Include %A_ScriptDir%\lib\VisualUtils.ahk
#Include %A_ScriptDir%\lib\FlowTime.ahk

<^>!SC01E:: 
  {
    ; AltGr + "A"
    Send {\}
    return
  }

<^>!SC01F:: 
  {
    ; AltGr + "S"
    Send {|}
    return
  }
<^>!SC021::
  {
    ; AltGr + "F"
    OpenHighlighted() 
  }

<^>!SC018::
  {
    ; AltGr + "O"
    pressedKey := ListenNextKey()
    if pressedKey is number
    {
      sendDesktopOrSwitchDesktop( pressedKey )
    }
    else if (pressedkey = "r") {
      switchDesktopToLastOpened()
    }
    else if ( pressedKey = "f") {
      OpenHighlighted()
    }
    else if ( pressedKey = "w") {
      alternateWindowMonitor()
    }
    else if ( pressedKey = "i") { 
      WinMaximize, A
    }
    else {
      WriteTip("Unknown key: " pressedKey)
    }

    return 
  } 

<^>!SC022::
  {
    ; AltGr + "G"
    pressedKey := ListenNextKey()
    if (pressedKey = "s") {
      ProcessArticles()
    } 
    else if (pressedKey = "m"){
      FlowChoose()
    }
    else if ( pressedKey = "q") {
      GrabUrl()
    }
    else {
      WriteTip("Unknown key: " pressedKey)
    }

    return
  } 


