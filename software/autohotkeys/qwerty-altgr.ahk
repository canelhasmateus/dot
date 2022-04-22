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
    return 
  } 
<^>!SC022::
  {
    pressedKey := GetNextKey()
    if (pressedKey = "s") {
      run python C:/Users/Mateus/Desktop/workspace/dot/software/scripting/daily_reads.py

    } else {

      url := GetBrowserUrl()
      if ( url ) {

        comment := ""

        ; Article Related
        if (pressedKey = "p") {
          comment := "Premium"
        }

        else if (pressedKey = "i") {
          comment := "Good"
        }
        else if (pressedKey = "h") {
          comment := "History"
        }

        else if (pressedKey = "k") {
          comment := "Bad"
        }
        else if (pressedKey = "l") {
          comment := "Revisit"
        }

        else if (pressedKey = "q") {
          comment := "Queue"
        }

        else if (pressedKey = "t") {
          comment := "Tool"
        }
        else if (pressedKey = "u") {
          comment := "Utility"
        }
        else if (pressedKey = "b") {
          comment := "Bookmark"
        }

        if (comment) {


          articleStream := "C:\Users\Mateus\OneDrive\vault\Canelhas\others\lists\articlesStream.txt"
          FileAppend, `n%A_YYYY%-%A_MM%-%A_DD%`t%A_Hour%:%A_Min%:%A_Sec%`t%comment%`t%url%, %articleStream%
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
