#NoEnv
#singleinstance force

CurrentMode := 0 ; 0 = Off, 1 = working, 2 = break
CurrentTask := ""
StartTime := A_TickCount
EndPause := A_TickCount
flowtimeLog := "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\flowtime.tsv"

SetMode(mode){
    global CurrentMode, StartTime, EndPause, CurrentTask
    
    CurrentTime := A_TickCount

    if ( mode == 0) {
        WriteTip("FlowTime: Off")
    }
    else if (mode == 1){
        ; Work Mode
        StartTime := CurrentTime
        InputBox ,CurrentTask, FlowTime, `nWhat will be your task?,  , 180 , 150
        if (ErrorLevel > 0) {
            return
        }
    } else if ( mode == 2){
        
        ; Break Mode
        breakLength := (CurrentTime - StartTime)*.4 ; length of break
        EndPause := CurrentTime + breakLength
        SetTimer, BackToWork, % "-" breakLength
        WriteTip("FlowTime: Break will take "  Floor(breakLength / 1000) " seconds")
    }
    CurrentMode := mode
    
    return
    
}


ToggleFlow() {
    global CurrentMode
    if ( CurrentMode == 1) {
        SetMode( 2 )
    }
    else {
        SetMode( 1 )
    }

}
DisableFlow() {    
    SetMode( 0 )
}
ShowFlow() {
    global CurrentMode, StartTime, EndPause
    
    if (CurrentMode == 0) {
    
        WriteTip("FlowTime is Off")
    
    }
    else if (CurrentMode == 1){
    
        elapsed := DiffSeconds( StartTime , A_TickCount) 
        WriteTip("FlowTime: Working For " elapsed " seconds")
    
    } else if ( CurrentMode == 2){
    
        elapsed := DiffSeconds( A_TickCount , EndPause )
        WriteTip("FlowTime: On Break for " elapsed " more")
    
    }
}


WriteTip( msg ) {
    ToolTip, %msg%, A_ScreenWidth - 200, A_ScreenHeight-100
    SetTimer, RemoveToolTip, -3000
    return
}

DiffSeconds( start , finish) {
    return Floor( (finish - start) / 1000 )
}

RemoveToolTip:
    ToolTip
    return

BackToWork:
    SoundBeep, 500, 1000
    msgbox Break is Over!
    SetMode(0)
    return
