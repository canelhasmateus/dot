#NoEnv
#singleinstance force
#Include %A_ScriptDir%\lib\VisualUtils.ahk

CurrentMode := 0 ; 0 = Off, 1 = working, 2 = break, 3 = interrupted
CurrentTask := ""
WorkStart := 0
WorkEnd := 0
BreakStart := 0
BreakEnd := 0
BreakLength := 0

SetMode( NextMode ){
    global CurrentMode, CurrentTask

    if ( NextMode = CurrentMode) {
        return
    }

    if (NextMode == 1){
        ; Work Mode
        CurrentTask := TaskChoose()
        if (!CurrentTask) {
            return
        }
        TaskInstructions( CurrentTask ) 

    } else if ( NextMode == 2){

        BreakInstructions( )
    }

    SetTimes( CurrentMode, NextMode )
    FlowLog( CurrentMode, NextMode, currentTask)
    CurrentMode := NextMode
    return

}
SetTimes( StartMode , EndMode) {
    global WorkStart, WorkEnd, BreakStart, BreakEnd, BreakLength

    ; -----

    if ( EndMode = 1) {
        ; Entering Work Mode
        WorkStart := GetUnixTime()
    }
    if (StartMode = 1) {
        ; Exiting Work Mode
        WorkEnd := GetUnixTime()
        BreakStart := GetUnixTime()
        BreakLength := BreakSize( WorkStart , WorkEnd )
        BreakEnd := Sum( BreakStart, BreakLength)
    }

    ; -----

}

FlowStop(){
    SetMode( 0 )
}
FlowStart(){
    SetMode( 1 )
}
FlowBreak(){
    SetMode( 2 )
}
FlowInterrupt(){
    SetMode( 3 )
    WriteTip("FlowTime: Interrupted")
}

FlowChoose() {
    global CurrentMode, CurrentTask, WorkStart, BreakEnd

    CurrentMode := Coalesce( CurrentMode , 0)
    if (CurrentMode = 0 || CurrentMode = 3){
        FlowStart() 
        return
    }
    else if ( CurrentMode = 1) {
        prompt := "Working at " CurrentTask " for " Diff( WorkStart , GetUnixTime() ) "s."
        options := ["Break", "Interrupt"] 
    }
    else if ( CurrentMode = 2 ) {
        prompt := "Breaking from " CurrentTask " for " Diff( GetUnixTime() , BreakEnd ) "s."
        options := ["Interrupt"] 
    }
    else {
        WriteTip( "CurrentMode not found: " CurrentMode)
        return
    }

    action := GatherChoice(prompt, options)
    if ( action = "Break" ) {
        FlowBreak()
    }
    else if ( action = "Interrupt" ) {
        FlowInterrupt()
    }
    else if (action) {
        WriteTip( "Action not understood: " action) 
    }
    return
}

; -----

FlowLog( ModeStart , ModeEnd, Task, Comment := "") {

    Comment := GatherComments( ModeStart, ModeEnd , Comment)
    Action := GetModeName( ModeEnd )
    Start :=GetHumanTime()
    content := "`n" Action "`t" Task "`t" Start "`t" Comment
    if (content) {
        flowtimeLog := "C:\Users\Mateus\OneDrive\gnosis\tholos\lists\stream\flowtime.tsv" 
        FileAppend, %content%, %flowtimeLog%
    }
    return

} 
GetModeName( mode ) {
    Expected := ["BreakEnd" , "WorkStart" , "WorkEnd" , "Interrupt"][ 1 + mode ]
    return Coalesce( Expected , "Unknown")
}
GatherComments( ModeStart, ModeEnd, Comment) {
    if ( ModeStart == 1 && ModeEnd != 1) {
        if (Comment == "") {
            Comment := GatherText("Any comments?")
        }
    } 

    return Coalesce( Comment , "None")
}
; -----

TaskChoose() {
    flowtimeTasks := "C:\Users\Mateus\OneDrive\gnosis\tholos\lists\stream\todos.txt"
    FileRead,content , %flowtimeTasks% 
    content := StrSplit(content , "`n")
    return AutoCompleteComboBox( "Start a task!", content)
}
TaskAlerts() {

    SetTimer, TaskOver, -54000000
    SetTimer, TaskTime, -18000000
    return

    TaskTime:
        global CurrentMode
        if ( CurrentMode = 1 ) {
            WriteTip( "30 minutes since task started." , 10000)
        }
    return

    TaskOver:
        global CurrentMode
        if ( CurrentMode = 1 ) {
            WriteTip("90 minutes since task started.`nCare to take a break?" , 10000)
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
    TaskAlerts()
    content = 
    (

        Working on %task%.
        -----------------------------

    Take care of your phisiology:
        * Coffee
        * Water
        * Bathroom
        * Reading Glasses

    Optimize your environment:
        * Distractions
        * Music
        * Scents
        * Lightning
        * Tidiness

        -----------------------------
        Have a good time! 

    )

    MsgBox,, Flowtime, %content%
    return 
}
; -----

BreakSize( start, finish ) {
    Duration := Diff( start , finish )
    Length := Ceil( 0.3 * Duration )
    if (Length <= 60) {
        Length := 60
    }
    if ( Length >= 1800) {
        Length := 1800
    }
    return Length
}

BreakInstructions( ) {
    global BreakLength

    BreakInSeconds := Coalesce( BreakLength , 60 )
    MilliBreak := 1000*BreakInSeconds
    SetTimer BreakOver, -%MilliBreak%
    WriteTip("FlowTime: Break for " BreakInSeconds "s")
    return

    BreakOver:
        global CurrentMode
        if (CurrentMode = 2 ) {
            SoundBeep, 500, 1000
            MsgBox Break is Over!
            FlowStop()
        }
    return
}

; ------

Diff( start, finish ) { 
    result = %finish%
    EnvSub result, %start%, seconds
    return result
}
Sum( start, offset ) { 
    result = %start%
    EnvAdd result, %offset%, seconds
    return result
}

GetUnixTime() {
    return A_Now
}
GetHumanTime() {
    currentTime := GetUnixTime()
    FormatTime, result, %currentTime%, yyyy/MM/dd HH:mm:ss
    return result
}
Coalesce( val , fallback ) {
    if (val == "" || val ==) {
    return fallback
}

return val

}

