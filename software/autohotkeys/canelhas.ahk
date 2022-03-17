#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#KeyHistory 0 ; Ensures user privacy when debugging is not needed
#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#Include %A_ScriptDir%\workspaces.ahk

GetNext() 
{
    Input pressedKey , L1 T3 B, {Esc}{BackSpace}
    return pressedKey
}

<^>!a:: 
    {
        Send {\}
        return
    }

<^>!s:: 
    {
        Send {|}
        return
    }

Space & ~o::
    {

        pressedKey := GetNext()
        if pressedKey is number 
        {
            send { BackSpace}
            send { BackSpace}
            switchDesktopByNumber( pressedKey)

        } 

        else if ( pressedKey == "r") 
        {

            send { BackSpace}
            send { BackSpace}
            switchDesktopToLastOpened()
        }
        else {
            send %pressedKey%
        }

        return
    }

Space & ~s:: 
    {

        pressedKey := GetNext()

        if (pressedKey == "s" ) {
            send { BackSpace}
            send { BackSpace}
            Reload
        }
        else {
            send %pressedKey%
        }

    }

Space & ~w::
    {

        pressedKey := GetNext()

        if ( pressedKey == "l"){
            send { BackSpace}
            send { BackSpace}
            switchDesktopToRight()
        }
        else if ( pressedKey== "j") {
            send { BackSpace}
            send { BackSpace}
            switchDesktopToLeft()
        }
        else {
            send %pressedKey%
        }

    }

~Space::
    {
        ; Send {Space}
    }

