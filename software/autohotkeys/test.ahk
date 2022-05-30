#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\lib\VisualUtils.ahk

globalState := 
breakEnd := 0

; ----- Pure Utilities
ToHumanTime( timestamp ) {
    FormatTime, result, %timestamp%, yyyy/MM/dd HH:mm:ss
    return result
}
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

StrRepeat(string, times) {
    output := ""

    loop % times
        output .= string

    return output
}
Coalesce( val , fallback ) {

    if (val == "" || val == ) {
        return fallback
    }

    return val

}
; ----- Core Logic
BreakSize( start, finish ) {
    Duration := Diff( start , finish )
    Length := Ceil( 0.3 * Duration )
    if (Length <= 5) {
        Length := 0
    }
    else if (Length <= 60) {
        Length := 60
    }
    else if ( Length >= 3600 ) {
        Length := 3600
    }
    return Length
}

AdvanceState( action , state) {

    if (!action) {
        return state
    }

    detail := "None"
    breakLength := 0
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
        task := { "Name" : "None" , "Start" : GetUnixTime()}
        newTasks := [ ]
        newMode := "Off"
    }
    else {
        return state
    }

    return { "Mode" : newMode , "Tasks" : newTasks , "Detail" : "None"}
}

; ------ Impure Utilities
_FormatForkMessage( state ) {
    tasks := state["Tasks"] 
    ; tasks := Coalesce( tasks , [ ])    
    message := "Currently Working:`n"
    for idx , obj in tasks {
        spaces := StrRepeat( " " , idx) 
        name := obj["Name"] 
        message .= "`n" spaces name
    }
    return message
}
_FormatOffMessage( state ) {
    ; Couldn't make this fit nicely. There goes a global :(
    global breakEnd
    remainingTime := Diff( GetUnixTime() , breakEnd)
    remainingTime := Coalesce( remainingTime , 0 )
    if ( remainingTime <= 0 ) {
        return "There is no time to explain.`n Get in the flow!"
    }
    else {
        return "Relaxing for " remainingTime " more seconds.`n`t...Or am i?!"
    }

}
_FormatStartMessage( state ) {

    task := state["Tasks"][ 1 ]
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

        return content
    }

    GetUnixTime() {
        return A_Now
    }

    LoadState() {
        state := { "Mode" : "Off" , "Tasks" : [] , "Detail" : "None"}
        ; Read History, update state. 
        return state
    }

    newDesktop() {
        ; todo Maybe check the number of currently opened desktops, and act accordingly?
        Sleep, 100
        Send {CtrlDown}{LWinDown}{d}{CtrlUp}{LWinUp}
        Sleep, 100
        return
    }
    ; ------ User Interface ; 

    _BreakInstructions( state ) {

        global breakEnd
        now := GetUnixTime() 
        breakLength := BreakSize( state["Tasks"][ 1 ]["Start"] , now )
        breakEnd := Sum(now , breakLength)
        MilliBreak := 1000*BreakInSeconds
        
        prefix := breakLength > 0 ?  "Relax for " breakLength ". " : ""
        comment := GatherText( prefix "Any thoughts on this session?")
        if (MilliBreak >= 60000) {
            SetTimer BreakOver, -%MilliBreak%
        }
        
        
        state["Detail"] = Coalesce( comment , "None")
        return state

        BreakOver:
            global globalState
            if (globalState["Mode"] == "Off" ) {
                SoundWind()
                MsgBox Break is Over!
            }
        return
    }
    _FlowInstructions( state ) {
        newDesktop()
        content := _FormatStartMessage( state )
        MsgBox,, Flowtime, %content%
        
        SetTimer, TaskTime, -18500000
        SetTimer, TaskTime, -36500000
        SetTimer, TaskTime, -54500000
        ; todo: Make this recurrent.
        state["Tasks"][0]["Start"] = GetUnixTime()
        return state

        TaskTime:
            global globalState
            mainTask := globalState["Tasks"][0]
            timeSince := Diff( mainTask["Start"] , GetUnixTime() )
            halfHours := timeSince / 1800
            if ( halfHours > 1) {
                Round(Number [, 0])
                minutePassed := Round(halfHours) * 30
                WriteTip( minutePassed "~ minutes since task started." , 10000)
                SoundChime()
            }
        return
    }
    ChooseAction( message , options) {
        choice := GatherChoice( message, options)
        if (choice == "Fork") {
            action := ChooseTask( "A wild subtask appeared!")
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
    ChooseTask( message ) {
        flowtimeTasks := "C:\Users\Mateus\OneDrive\gnosis\tholos\lists\stream\todos.txt"
        FileRead,content , %flowtimeTasks% 
        content := Trim(content, OmitChars = "`n `t")
        content := StrSplit(content , "`n")
        task := AutoCompletingView( message , content)
        if ( task ) {
            action := { "Action" : "Fork" , "Task" : { "Name" : task , "Start" : GetUnixTime() }}
        }
        return action
    }
    ; -----

    DisplayUI( ) {
        global globalState
        if ( !globalState ) {
            globalState := LoadState()    
        }
        
        ; ----- 
        state := globalState
        currentMode := state["Mode"]
        if (currentMode == "Flow") {
            message := _FormatForkMessage( state ) 
            action := ChooseAction( message , [ "Fork" , "Join" , "Gather" , "Break"] )
        }
        else if (currentMode == "Off") {
            message := _FormatOffMessage( state ) 
            action := ChooseTask( message)
        }
        else {
            WriteTip( "Flowtime in unknown state. " currentMode)
            return
        }
        ; -----
        newState := AdvanceState( action , state )
        if (!newState) {
            return 
        }
        newMode := newState["Mode"]
        if ( newMode == "Off" && currentMode == "Flow") { 
            newState := _BreakInstructions( newState )
        } 
        else if ( newMode == "Flow" && currentMode != "Flow") {
            newState := _FlowInstructions( newState )
        }
        globalState := newState

        return 
    }

    ; ----- 

    

loop % 10
    DisplayUI()