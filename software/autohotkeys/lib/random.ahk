
OpenHighlighted()
{
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

; #SingleInstance, Force
; SetWorkingDIr, A_ScriptDir
; SetBatchLines,-1
; ;#Include Acc.ahk																	; https://github.com/Drugoy/Autohotkey-scripts-.ahk/blob/master/Libraries/Acc.ahk

; F11::MsgBox % clipboard := GetChromeUrl()											; copying the address bar content of the TAB that's on focus. Remove 'MsgBox %' after testing. 
; F12::MsgBox % clipboard := GetChromeUrl(WinExist("ahk_class Chrome_WidgetWin_1"))	; this will extract an URL even if the browser itself isn't on focus.

; GetChromeUrl(hWnd:="") {
; 	local
; 	hWnd := (hWnd = "") ? WinExist("A") : hwnd
; 	oAcc := Acc_Get("Object", "4.1.1.2.1.2.5.3", 0, "ahk_id " hWnd)		; "4.1.1.2.1.2.5.3" valid for Chrome (v98). Please update accordingly - using ACCViewer.ahk
; 	if !IsObject(oAcc) || !(oAcc.accName(0) = "Address and search bar")
; 		oAcc := Acc_Get("Object", "4.1.1.2.1.2.5.3", 0, "ahk_id " hWnd)	; see above.
; 	vUrl := oAcc.accValue(0),  oAcc := ""
; 	return vUrl
; 	}

; GetUwpAppName() {
; 	; https://www.autohotkey.com/boards/viewtopic.php?p=73137#p73137
;     WinGet name,ProcessName,A
;     if(name="ApplicationFrameHost.exe") {
;         ControlGet hWnd,Hwnd,,Windows.UI.Core.CoreWindow1,A
;         if(hWnd)
;             WinGet name,ProcessName,ahk_id %hWnd%
;     }
;     return name
; }

; GetURL() {
; 	if(WinActive("ahk_exe chrome.exe"))
; 		return Acc_Get("Object","4.1.2.2.2",0,"A").accValue(0)
; 	if(WinActive("ahk_exe firefox.exe"))
; 		return Acc_Get("Object","4.22.8.1",0,"A").accValue(0)
; 	if(WinActive("ahk_class IEFrame"))
; 		return Acc_Get("Object","4.3.4.1.4.3.4.2.2",0,"A").accValue(0)
; 	if(GetUwpAppName()="MicrosoftEdge.exe") {
; 		items:=Acc_Children(Acc_Get("Object","4.2.4",0,"A"))
; 		Loop % items.length()
; 			if(items[A_Index].accRole(0)=ACC_ROLE.TEXT)
; 				return items[A_Index].accValue(0)
; 	}
; 	ClipSaved:=ClipboardAll
; 	Clipboard=
; 	Sleep 100
; 	Send ^l^c ; Ctrl+l would also work in ALL four browsers from above. But nevertheless: this line is untested!
; 	ClipWait 0.1
; 	url:=Clipboard
; 	Clipboard:=ClipSaved
; 	ClipSaved=
; 	return url
; }

