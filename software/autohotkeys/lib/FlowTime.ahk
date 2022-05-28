#NoEnv
#singleinstance force
#Include %A_ScriptDir%\lib\VisualUtils.ahk

CurrentMode := 0 ; 0 = Off, 1 = working, 2 = break
CurrentTask := ""
WorkStart := 0
WorkEnd := 0
BreakStart := 0
BreakEnd := 0
BreakLength := 0

SetMode(mode , flowStatus){
    global CurrentMode, CurrentTask, WorkStart

    if ( mode = CurrentMode) {
        ; No Changes , Do Nothing
        return
    }

    if (mode == 1){
        ; Work Mode
        CurrentTask := ""
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

    FlowLog( CurrentMode , flowStatus )
    CurrentMode := mode

    return

}
SetTimes( mode ) {
    global CurrentMode, WorkStart, WorkEnd, BreakStart, BreakEnd, BreakLength
    ; -----

    if ( mode = 1) {
        ; Entering Work Mode
        WorkStart := GetUnixTime()
    }
    if (CurrentMode = 1) {
        ; Exiting Work Mode
        WorkEnd := GetUnixTime()
    }

    ; -----

    if ( mode = 2 ) {
        ; Entering Break Mode
        BreakStart := GetUnixTime()
        BreakLength := BreakSize( WorkStart , WorkEnd )
        BreakEnd := BreakStart + BreakLength
    }

}

FlowInterrupt(){
    SetMode( 0 , "Interrupt" )
}
FlowStop(){
    SetMode( 0 , "Ok")
}
FlowStart(){
    SetMode( 1 , "Ok" )
}
FlowBreak(){
    SetMode( 2 , "Ok" )
}
FlowChoose() {
    global CurrentMode, CurrentTask, WorkStart, BreakEnd
    if ( CurrentMode != 0 && CurrentMode != 1 && CurrentMode != 2 ) {
        CurrentMode := 0
    }

    if (CurrentMode = 0){
        FlowStart() 
        return
    }
    else if ( CurrentMode = 1) {
        prompt := "Working at " CurrentTask " for " AsSeconds( WorkStart , GetUnixTime() ) "s."
        options := ["Break", "Interrupt"] 
    }
    else if ( CurrentMode = 2 ) {
        prompt := "Breaking from " CurrentTask " for " AsSeconds( GetUnixTime() , BreakEnd ) "s."
        options := ["Interrupt"] 
    }
    else {
        WriteTip( "CurrentMode not found: " CurrentMode)
        return
    }

    action := AutoCompleteComboBox(prompt, options)
    if ( action = "Break" ) {
        FlowBreak()
    }
    else if ( action = "Interrupt" ) {
        FlowInterrupt()
    }
    return
}

FlowLog( mode, flowStatus ) {
    global CurrentTask, WorkStart, WorkEnd, BreakStart, BreakEnd

    flowtimeLog := "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\flowtime.tsv" 
    if (mode = 1) { 
        content := "`nWork`t" CurrentTask "`t" WorkStart "`t" GetUnixTime() "`t" flowStatus
    }
    else if ( mode = 2){
        content := "`nBreak`t" CurrentTask "`t" BreakStart "`t" GetUnixTime() "`t" flowStatus
    }

    if (content) {
        FileAppend, %content%, %flowtimeLog%
    }

}

; -----

TaskChoose() {
    flowtimeTasks := "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\todos.txt"
    FileRead,content , %flowtimeTasks% 
    content := StrSplit(content , "`n")
    return AutoCompleteComboBox( "Working on what?", content)
}
TaskExpire() {
    ninetyMinutes = -54000000
    SetTimer, TaskOver, %ninetyMinutes%
    return

    TaskOver:
        global CurrentMode, CurrentTask
        if ( CurrentMode = 1 ) {
            MsgBox,, Flowtime, It has been quite sometime since you started %CurrentTask%. `nCare to take a break?
        }
    return
}
TaskDesktop() {
    Sleep, 100
    Send {CtrlDown}{LWinDown}{d}{CtrlUp}{LWinUp}
    Sleep, 100
    return
}
TaskInstructions( task) {
    TaskDesktop()
    TaskExpire()
    WriteTip("FlowTime: Working on " task)
    return 
}
; -----

BreakSize( start, finish ) {
    return Floor( 0.4 * (finish - start) )
}
BreakInstructions( ) {

    global BreakStart, BreakEnd, BreakLength

    SetTimer, BreakOver, % "-" BreakLength
    WriteTip("FlowTime: Break will take " AsSeconds( BreakStart , BreakEnd) "s")
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

AsSeconds( start, finish ) { 
    return Floor( (finish - start) / 1000 )
}
GetUnixTime() {
    return A_TickCount
}

