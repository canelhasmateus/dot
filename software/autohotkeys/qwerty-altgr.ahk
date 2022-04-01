#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\lib\workspaces.ahk
#Include %A_ScriptDir%\lib\random.ahk
#Include %A_ScriptDir%\lib\accData.ahk


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
<^>!SC022::
  {
    pressedKey := GetNextKey()
    url := GetBrowserUrl()
    if ( url ) {
      
      file := ""

      if (pressedKey = "i") {
        file := "urlsGood.txt"
      }
      else if (pressedKey = "k") {
        file := "urlsBad.txt"
      }
      else if (pressedKey = "j") {
        file := "urlsBase.txt"
      }
      else if (pressedKey = "l") {
        file := "urlsUnsure.txt"
      }
      
      if (file) {
        myFileName := "C:\Users\Mateus\OneDrive\vault\Canelhas\others\scratchpads\" file
    
        FileAppend, `n %url%, %myFileName%
        TrayTip ,, Saved to %file%
      }
       



    }
   
    return
  } 


