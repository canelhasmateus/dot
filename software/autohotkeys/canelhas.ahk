#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
;#KeyHistory 0 ; Ensures user privacy when debugging is not needed
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
            send {alt down}{tab}{alt up}

        } 

        else if ( pressedKey == "r") 
        {

            send { BackSpace}
            send { BackSpace}
            switchDesktopToLastOpened()
            send {alt down}{tab}{alt up}
        }
        else {
            send %pressedKey%
        }

        return
    }
    
SC073::
    {

        send { SHIFT DOWN}
        return

    }

SC073 up::
{
    
    send {SHIFT UP}
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
            send {alt down}{tab}{alt up}
        }
        else if ( pressedKey== "j") {
            send { BackSpace}
            send { BackSpace}
            switchDesktopToLeft()
            send {alt down}{tab}{alt up}
        }
        else {
            send %pressedKey%
        }

    }

~Space::
    {
        ; Send {Space}
    }

