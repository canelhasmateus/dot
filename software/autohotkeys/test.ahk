#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\lib\VisualUtils.ahk

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

TaskEnd( ) {

}
TaskStart( task ) {
}

UpdateState( action , state) {

    if (!action) {
        return state
    }

    detail := "None"
    timestamp := ""

    newMode := "Off"
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

    return UpdateState( action , state )

}

currentStatus := { "Tasks" : [ ] }
currentStatus[ "Mode" ] := "Off"

loop % 10
    DisplayUI(currentStatus)