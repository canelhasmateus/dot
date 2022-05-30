#NoEnv
#singleinstance force
#Include %A_ScriptDir%\lib\VisualUtils.ahk

globalState :=  { }

StrRepeat(string, times) {
    output := ""

    loop % times
        output .= string

    return output
}
_FormatTaskMessage( tasks ) {
    ; tasks := Coalesce( tasks , [ ])    
    message := "Currently Working:`n"
    for idx , obj in tasks {
        spaces := StrRepeat( " " , idx) 
        name := obj["Name"] 
        message .= "`n" spaces name
    }
    return message
}

UpdateState( action , state) {

    if (!action) {
        return state
    }

    detail := "None"
    timestamp := "" ; 
    newMode := state["Mode"]
    newTasks := state["Tasks"].Clone()

    actionName := action["Action"]
    if (actionName == "Fork") {
        task := action["Task"]
        newTasks.Push( task )
        newMode := "Flow"
    }
    else if ( actionName == "Join") {
        task := newTasks.Pop()
        ; 
        newMode := newTasks.Count() == 0 ? "Off" : "Flow"
    }
    else if ( actionName == "Gather" || actionName == "Break") {
        task := { "Name" : "None"}
        newTasks := [ ]
        newMode := "Off"
    }

    return { "Mode" : newMode , "Tasks" : newTasks , "LastUpdate" : timestamp , "Detail" : "None"}
}

DisplayFork( ) {
    flowtimeTasks := "C:\Users\Mateus\OneDrive\gnosis\tholos\lists\stream\todos.txt"
    FileRead,content , %flowtimeTasks% 
    content := StrSplit(content , "`n")
    task := AutoCompleteComboBox( "Start a task!", content)
    if ( task ) {
        action := { "Action" : "Fork" , "Task" : { "Name" : task }}
    }
    return action
}

DisplayFlow( state ) {
    message := _FormatTaskMessage( state["Tasks"] ) 
    options := [ "Fork" , "Join" , "Gather" , "Break"] 
    choice := GatherChoice( message, options)

    if (choice == "Fork") {
        action := DisplayFork()
    }
    else if ( choice == "Join") {
        action := { "Action" : "Join" }
    }
    else if ( choice == "Gather") {
        action := { "Action" : "Gather" }
    }
    else if ( choice == "Break") {
        action := { "Action" : "Break" }
    }
    else if ( choice ) {
        WriteTip( "Flowtime: unknown choice: " choice) 
    }

    return action
}

DisplayUI( state ) {

    currentMode := state["Mode"]
    if (currentMode == "Flow") {
        action := DisplayFlow( state )
    }
    else if (currentMode == "Off") {
        action := DisplayFork()
    }
    else {
        WriteTip( "Flowtime in unknown state.")
    }
    
    newState := UpdateState( action , state )
    
    if (newState != state) {
        return newState
    }
    return DisplayUI( newState )
}

FlowLoad() {
    global CurrentMode, CurrentStatus    
    CurrentMode := Coalesce( CurrentMode , 0)
    
    FlowLoad()
    mode = Coalesce( CurrentMode , 0 )
    CurrentStatus := { "CurrentMode" : mode }
    return CurrentStatus
}

; ---

; ---

GatherComments( ModeStart, ModeEnd, Comment) {
    if ( ModeStart == 1 && ModeEnd != 1) {
        if (Comment == "") {
            Comment := GatherText("Any comments?")
        }
    } 

    return Coalesce( Comment , "None")
}

FlowSave( currentStatus, Comment := "") {
    Start :=GetHumanTime()
    content := "`n" Action "`t" Task "`t" Start "`t" Comment
    if (content) {
        flowtimeLog := "C:\Users\Mateus\OneDrive\gnosis\tholos\lists\stream\flowtime.tsv" 
        FileAppend, %content%, %flowtimeLog%
    }
}
; -----


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

