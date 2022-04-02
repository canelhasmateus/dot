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

      ; Article Related
      if (pressedKey = "p") {
        file := "articlesPremium.txt"
      }

      else if (pressedKey = "i") {
        file := "articlesGood.txt"
      }

      else if (pressedKey = "k") {
        file := "articlesBad.txt"
      }
      else if (pressedKey = "l") {
        file := "articlesUnsure.txt"
      }

      else if (pressedKey = "q") {
        file := "articlesQueue.txt"
      }

      ; Page Related
      else if (pressedKey = "t") {
        file := "pageTools.txt"
      }
      else if (pressedKey = "u") {
        file := "pageUtilities.txt"
      }
      else if (pressedKey = "b") {
        file := "pageBookmark.txt"
      }


      ; Explore Related
      else if (pressedKey = "e") {
        file := "urlsExploreQueue.txt"
      }
      else if (pressedKey = "d") {
        file := "urlsExploreDone.txt"
      }
      
      if (file) {
        myFileName := "C:\Users\Mateus\OneDrive\vault\Canelhas\others\lists\" file

        FileAppend, `n%A_YYYY%-%A_MM%-%A_DD% %url%, %myFileName%
        SoundPlay %A_ScriptDir%\blob\xylo.wav

      }

    }

    return
  } 

