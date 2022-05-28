#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%
#Include %A_ScriptDir%\lib\accData.ahk
#Include %A_ScriptDir%\lib\FlowTime.ahk
#Include %A_ScriptDir%\lib\VisualUtils.ahk

GetBrowserUrl() {
    accData:= GetAccData() ; parameter: "A" (default), "WinTitle", "ahk_class IEFrame", "ahk_exe chrome.exe", etc.
    if ( accData ) {
        return accData.2
    }
}

GrabUrl(){

    url := GetBrowserUrl()

    if (!url) {
        WriteTip("No url found.")
        return
    } 

    chosenQuality := AutoCompleteComboBox("Choose a quality" , ["Premium" , "Good" , "History" , "Bookmark" , "Bad", "Queue" , "Revisit" , "Tool" , "Utility" , "Explore" , "Done" ]) 
    if (chosenQuality) { 
        destination = "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\stream\articles.tsv"
        FileAppend, `n%A_YYYY%-%A_MM%-%A_DD%`t%A_Hour%:%A_Min%:%A_Sec%`t%chosenQuality%`t%url%, %destination%
        SoundPlay %A_ScriptDir%\blob\xylo.wav
    }
}

OpenHighlighted() {
    MyClipboard := "" ; Clears variable
    previousClip := clipboard
    Send, {ctrl down}c{ctrl up} ; More secure way to Copy things
    ClipWait 1
    MyClipboard := RegexReplace( clipboard, "^\s+|\s+$" ) ; Trim additional spaces and line return
    MyStripped := StrReplace(MyClipboard, " ", "") ; Removes every spaces in the string.

    StringLeft, OutputVarUrl, MyStripped, 7 ; Takes the 8 firsts characters
    StringLeft, OutputVarLocal, MyStripped, 3 ; Takes the 3 first characters

    if (OutputVarUrl == "http://" || OutputVarUrl == "https:/")
        Desc := "URL", Target := MyStripped
    else if (OutputVarLocal == "C:/" || OutputVarLocal == "C:\" || OutputVarLocal == "Z:/" || OutputVarLocal == "Z:\" || OutputVarLocal == "R:/" || OutputVarLocal == "R:\" ||)
        Desc := "Windows", Target := MyClipboard
    else
        Desc := "GoogleSearch", Target := "http://www.google.com/search?q=" MyClipboard

    TrayTip,, %Desc%: "%MyClipboard%" ;
    Run, %Target%
    Clipboard := previousClip
    Return
}

ProcessArticles() {
    run python "C:\Users\Mateus\OneDrive\vault\Canelhas\lists\scripts\update.py"
}

; -----

