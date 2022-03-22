#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
;#KeyHistory 0 ; Ensures user privacy when debugging is not needed
#SingleInstance Force ; The script will Reload if launched while already running
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.


#Include %A_ScriptDir%\extend-qwerty.ahk

; Basic Alt-GR to \ and |.

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

    

; remaps / ? to Shift
*SC073::
    {

        send {blind}{ SHIFT DOWN}
        return

    }

*SC073 up::
{
    
    send {BLIND}{SHIFT UP}
    return
}

; remaps \ | to Ctrl
*SC056::
{   
    send {BLIND}{CtrlDown}
    return
}

*SC056 up::
{ 
    send {BLIND}{CtrlUp}
    return
} 

; https://forum.colemak.com/topic/2675-share-your-favorite-extend-tricks/
; https://dreymar.colemak.org/layers-extend.html
