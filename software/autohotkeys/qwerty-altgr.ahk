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
      run python "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\scripts\update.py"

    } else {

      url := GetBrowserUrl()
      if ( url ) {
      
        if (pressedKey == "p") {
          kind := "articles.tsv"
          quality := "Premium"
        }          
        else if (pressedKey == "i"){
          kind := "articles.tsv"
          quality := "Good"
        }
        else if (pressedKey == "h"){
          kind := "articles.tsv"
          quality := "History"
        }
        else if ( pressedKey == "b") {
          kind := "articles.tsv"
          quality := "Bookmark"

        }
        else if ( pressedKey == "k") {
          kind := "articles.tsv"
          quality := "Bad"

        }
        else if ( pressedKey == "q") {
          kind := "articles.tsv"
          quality := "Queue"

        }
        else if ( pressedKey == "l") {
          kind := "articles.tsv"
          quality := "Revisit"

        }
        else if ( pressedKey == "t") {
          kind := "urls.tsv"
          quality := "Tool"

        }
        else if ( pressedKey == "u") {
          kind := "urls.tsv"
          quality := "Utility"
        }
        else if ( pressedKey == "e") {
          kind := "urls.tsv"
          quality := "Explore"
        }
        else if ( pressedKey == "d") {
          kind := "urls.tsv"
          quality := "Done"
        }
        
        if (kind) {
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
