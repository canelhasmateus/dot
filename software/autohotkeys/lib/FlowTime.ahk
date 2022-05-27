#NoEnv
#singleinstance force
#Include %A_ScriptDir%\lib\workspaces.ahk
#Include %A_ScriptDir%\lib\csv.ahk

CurrentMode := 0 ; 0 = Off, 1 = working, 2 = break
CurrentTask := ""

WorkStart := 0
WorkEnd := 0
BreakStart := 0
BreakEnd := 0
BreakLength := 0

SetMode(mode , flowStatus){
    global CurrentMode, CurrentTask, WorkStart, StartTime
    if ( mode = CurrentMode) {
        ; No Changes , Do Nothing
        return
    }

    if (mode == 1){
        ; Work Mode
        CurrentTask := TaskChoose()
        if (!CurrentTask) {
            return
        }
        SetTimes( mode )
        TaskInstructions( CurrentTask ) 

    } else if ( mode == 2){
        SetTimes( mode )
        BreakInstructions( )
    }

    FlowFlush( CurrentMode , flowStatus )
    CurrentMode := mode

    return

}
SetTimes( mode ) {
    global CurrentMode, WorkStart, WorkEnd, BreakStart, BreakEnd, BreakLength
    ; -----

    if ( mode = 1) {
        ; Entering Work Mode
        WorkStart := A_TickCount
    }
    if (CurrentMode = 1) {
        ; Exiting Work Mode
        WorkEnd := A_TickCount
    }

    ; -----

    if ( mode = 2 ) {
        ; Entering Break Mode
        BreakStart := A_TickCount
        BreakLength := BreakSize( WorkStart , WorkEnd )
        BreakEnd := BreakStart + BreakLength
    }

}
; -----
FlowFlush( mode, flowStatus ) {
    global CurrentTask, WorkStart, WorkEnd, BreakStart, BreakEnd

    flowtimeLog := "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\flowtime.tsv" 
    if (mode = 1) { 
        content := "`nWork`t" CurrentTask "`t" WorkStart "`t" A_TickCount "`t" flowStatus
    }
    else if ( mode = 2){
        content := "`nBreak`t" CurrentTask "`t" BreakStart "`t" A_TickCount "`t" flowStatus
    }

    if (content) {
        FileAppend, %content%, %flowtimeLog%
    }

}
FlowShow() {
    global CurrentMode, StartTime, EndPause, CurrentTask

    if (CurrentMode == 0) {
        WriteTip("FlowTime is Off")
    }
    else if (CurrentMode == 1){
        elapsed := AsSeconds( A_TickCount - StartTime ) 
        WriteTip("FlowTime: Working at " CurrentTask " (" elapsed "s)")

    } else if ( CurrentMode == 2){
        elapsed := AsSeconds( EndPause - A_TickCount )
        WriteTip("FlowTime: Break from " CurrentTask " (" elapsed "s)")
    }
}
FlowToggle() {
    global CurrentMode

    mode := CurrentMode
    if ( CurrentMode = 1) {
        SetMode( 2 , "Ok")
    }
    else {
        SetMode( 1 , "Ok")
    }

}
FlowStop() { 
    SetMode( 0 , "Interrupt")
}
; -----
TaskRead() {
    flowtimeTasks := "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\todos.txt"
    FileRead,content , %flowtimeTasks%    
    return StrSplit(content , "`n")
}

TaskChoose() {
    Global ChosenTask

    Gui, +LastFound
    GuiHWND := WinExist() ;--get handle to this gui..

    Gui, Add , Text , , What Are We Gonna Do?
    Gui, Add , ComboBox,vChosenTask
    Gui, Add , Button, Default, OK
    Gui, Show
    
    
    
    for k, v in TaskRead() {
        GuiControl,, ChosenTask, % v "|"
    }

    WinWaitClose, ahk_id %GuiHWND% ;--waiting for 'gui to close
    return ChosenTask

    ;-------

    ButtonOK:
        GuiControlGet, ChosenTask
        Gui, Destroy
    return
    ;-------

    GuiEscape:
    GuiClose:
        Gui, Destroy
    return

}

TaskInstructions( task) {
    Sleep, 100
    Send {CtrlDown}{LWinDown}{d}{CtrlUp}{LWinUp}
    Sleep, 100

    ninetyMinutes = -54000000
    SetTimer, TaskOver, %ninetyMinutes%
    WriteTip("FlowTime: Working on " task)
    return

    TaskOver:
        global CurrentMode, CurrentTask
        if ( CurrentMode = 1 ) {
            MsgBox,, Flowtime, It has been quite sometime since you started %CurrentTask%. `nCare to take a break?
        }
    return
}
; -----
BreakSize( start, finish ) {
    return Floor( 0.4 * (finish - start) )
}
BreakInstructions( ) {

    global BreakLength

    SetTimer, BreakOver, % "-" BreakLength
    WriteTip("FlowTime: Break will take " AsSeconds( BreakLength ) "s")
    return

    BreakOver:
        global CurrentMode
        if (CurrentMode = 2 ) {
            SoundBeep, 500, 1000
            MsgBox Break is Over!
            SetMode(0 , "Ok")
        }
    return
}

; ------

WriteTip( msg ) {
    ToolTip, %msg%, A_ScreenWidth - 200, A_ScreenHeight-100
    SetTimer, RemoveToolTip, -3000
    return

    RemoveToolTip:
        ToolTip
    return
}

AsSeconds( l ) { 
    return Floor(l / 1000)
}

