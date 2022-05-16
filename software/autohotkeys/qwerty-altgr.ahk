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

    } else {
      url := GetBrowserUrl()
      if ( url ) {
        kind := "articles.tsv"
      
        if (pressedKey == "p") {
          quality := "Premium"
        }          
        else if (pressedKey == "i"){
          quality := "Good"
        }
        else if (pressedKey == "h"){
          quality := "History"
        }
        else if ( pressedKey == "b") {
          quality := "Bookmark"
        }
        else if ( pressedKey == "k") {
          quality := "Bad"

        }
        else if ( pressedKey == "q") {
          quality := "Queue"

        }
        else if ( pressedKey == "l") {
          quality := "Revisit"

        }
        else if ( pressedKey == "t") {
          quality := "Tool"
        }
        else if ( pressedKey == "u") {
          quality := "Utility"
        }
        else if ( pressedKey == "e") {
          quality := "Explore"
        }
        else if ( pressedKey == "d") {
          quality := "Done"
        }
        
        if (quality) {
          root := "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\"
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

