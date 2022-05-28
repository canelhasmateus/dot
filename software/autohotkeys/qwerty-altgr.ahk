#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\lib\workspaces.ahk
#Include %A_ScriptDir%\lib\random.ahk
#Include %A_ScriptDir%\lib\accData.ahk
#Include %A_ScriptDir%\lib\FlowTime.ahk
#Include %A_ScriptDir%\lib\VisualUtils.ahk

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
    else if ( pressedKey = "w") 
    {

      alternateWindowMonitor()

    }
    else if ( pressedKey = "i") 
    { 
      WinMaximize, A
    }
    
    return 
  } 
<^>!SC022::
  {
    pressedKey := GetNextKey()
    if (pressedKey = "s") {
      run python "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\scripts\update.py"
    } 
    else if (pressedKey = "m"){
      isShift := GetKeyState( "Shift")
      if (isShift == 1 ) {
        FlowShow()
      }
      else {
        FlowToggle()
      }  
    }
    else if (pressedKey = "n"){
      FlowStop()
    }
    else if ( pressedKey = "q") {
      url := GetBrowserUrl()
      if ( url ) {
        
        
        chosenQuality := AutoCompleteComboBox("Choose a quality" , ["Premium" , "Good" , "History" , "Bookmark" , "Bad", "Queue" , "Revisit" , "Tool" , "Utility" , "Explore" , "Done" ])    
        if (chosenQuality) {
          root := "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\"
          kind := "articles.tsv"
          destination = %root%%kind%  

          FileAppend, `n%A_YYYY%-%A_MM%-%A_DD%`t%A_Hour%:%A_Min%:%A_Sec%`t%quality%`t%url%, %destination%
          SoundPlay %A_ScriptDir%\blob\xylo.wav
        }
      }
    }

    return
  } 

<^>!SC021::
  {
    OpenHighlighted() 
  }

