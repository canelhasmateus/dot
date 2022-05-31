
/*
	=======================================================================================
	 Function:			SHAutoComplete
	 Description:		Auto-completes typed values in an edit with various options.
	 Usage:
		Gui, Add, Edit, w200 h21 hwndEditCtrl1
		SHAutoComplete(EditCtrl1)
	=======================================================================================
*/
_SHAutoComplete(hEdit, Option := 0x20000000) {
	; https://bit.ly/335nOYt		For more info on the function.
	DllCall("ole32\CoInitialize", "Uint", 0)
	; SHACF_AUTOSUGGEST_FORCE_OFF (0x20000000)
	;	Ignore the registry default and force the AutoSuggest feature off.
	;	This flag must be used in combination with one or more of the SHACF_FILESYS* or SHACF_URL* flags.
	; AKA. It won't autocomplete anything, but it will allow functionality such as Ctrl+Backspace deleting a word.
	DllCall("shlwapi\SHAutoComplete", "Uint", hEdit, "Uint", Option)
	DllCall("ole32\CoUninitialize")
}

/*
	=======================================================================================
	 Function:			CbAutoComplete
	 Description:		Auto-completes typed values in a ComboBox.

	 Author:			Pulover [Rodolfo U. Batista]
	 Usage:
		Gui, Add, ComboBox, w200 h50 gCbAutoComplete, Billy|Joel|Samual|Jim|Max|Jackson|George
	=======================================================================================
*/
CbAutoComplete() {
	; CB_GETEDITSEL = 0x0140, CB_SETEDITSEL = 0x0142
	If ((GetKeyState("Delete", "P")) || (GetKeyState("Backspace", "P")))
		Return
	GuiControlGet, lHwnd, Hwnd, %A_GuiControl%
	SendMessage, 0x0140, 0, 0,, ahk_id %lHwnd%
	_MakeShort(ErrorLevel, Start, End)
	GuiControlGet, CurContent,, %lHwnd%
	GuiControl, ChooseString, %A_GuiControl%, %CurContent%
	If (ErrorLevel) {
		ControlSetText,, %CurContent%, ahk_id %lHwnd%
		PostMessage, 0x0142, 0, _MakeLong(Start, End),, ahk_id %lHwnd%
		Return
	}
	GuiControlGet, CurContent,, %lHwnd%
	PostMessage, 0x0142, 0, _MakeLong(Start, StrLen(CurContent)),, ahk_id %lHwnd%
}

; Required for: CbAutoComplete()
_MakeLong(LoWord, HiWord) {
	Return, (HiWord << 16) | (LoWord & 0xffff)
}

; Required for: CbAutoComplete()
_MakeShort(Long, ByRef LoWord, ByRef HiWord) {
	LoWord := Long & 0xffff, HiWord := Long >> 16
}

ListenNextKey() 
{
	Input pressedKey, M L1 T2 B, {Escape}{Tab}{Backspace}
	return pressedKey
}

AutoCompletingListView( prompt , options ) {
	Global ChosenOption

	ChosenOption := ""
	Gui, 2:+LastFound
	GuiHWND := WinExist() ;--get handle to this gui..
	Gui, 2:Default
	Gui, 2:Add , Text , Center w700, %prompt%
	Gui, 2:Add , ListView,h400 w700, Todo
	Gui, 2:Add , ComboBox, h400 w700 vChosenOption gCbAutoComplete
	Gui, 2:Add , Button, gButtonComplete, OK
	Gui, 2:Show

	for k, v in options { 
		GuiControl,2:, ChosenOption, % v "|"
		LV_Add("", v)		
	}
	GuiControl, 2:Focus, ChosenOption
	WinWaitClose, ahk_id %GuiHWND% ;--waiting for 'gui to close
	StringReplace, ChosenOption, ChosenOption, `n,, All
	StringReplace, ChosenOption, ChosenOption, `r,, All
	return ChosenOption

	;-------

	ButtonComplete:
		GuiControlGet, ChosenOption
		Gui, 2:Destroy
	return
	;-------

	2GuiEscape:
	2GuiClose:
		Gui, 2:Destroy
	return

}

GatherText( prompt ) {

	Global ChosenOption

	ChosenOption := ""
	Gui, 3:+LastFound
	GuiHWND := WinExist() ;--get handle to this gui..

	Gui, 3:Add , Text , Center, %prompt%
	Gui, 3:Add , Edit, vChosenOption
	Gui, 3:Add , Button, gButtonGather, OK
	Gui, 3:Show

	WinWaitClose, ahk_id %GuiHWND% ;--waiting for 'gui to close
	return ChosenOption

	;-------

	ButtonGather:
		GuiControlGet, ChosenOption
		Gui, 3:Destroy
	return
	;-------

	3GuiEscape:
	3GuiClose:
		Gui, 3:Destroy
	return

	
}
GatherChoice( prompt , options ) {
	Global ChosenOption

	ChosenOption := ""
	Gui, 4:+LastFound
	GuiHWND := WinExist() ;--get handle to this gui..

	Gui, 4:Add , Text , , %prompt%
	Gui, 4:Add , ListBox, vChosenOption
	Gui, 4:Add , Button, gButtonList, OK
	Gui, 4:Show

	for k, v in options { 
		if (k == 1) {
			GuiControl,4:, ChosenOption, % v "||"
		}
		else {
			GuiControl,4:, ChosenOption, % v "|"
		}
		
	}

	WinWaitClose, ahk_id %GuiHWND% ;--waiting for 'gui to close
	return ChosenOption

	;-------

	ButtonList:
		GuiControlGet, ChosenOption
		Gui, 4:Destroy
	return
	;-------

	4GuiEscape:
	4GuiClose:
		Gui, 4:Destroy
	return

}
WriteText( msg ) {


	Gui, 5:+LastFound +MaximizeBox
	
	GuiHWND := WinExist() ;--get handle to this gui..
	Gui, 5:Add , Text ,Left, %msg%
	Gui, 5:Add , Button, gButtonText, OK
	Gui, 5:Show
	WinWaitClose, ahk_id %GuiHWND% ;--waiting for 'gui to close
	return


	ButtonText:
	5GuiEscape:
	5GuiClose:
		Gui, 5:Destroy
	return


}
WriteTip( msg , duration := 3000) {
	ToolTip, %msg%, A_ScreenWidth - 200, A_ScreenHeight-100
	SetTimer, RemoveToolTip, -%duration%
	return

	RemoveToolTip:
		ToolTip
	return
}
SoundWind() {
	SoundPlay, %A_ScriptDir%\blob\windchime.wav 
}
SoundChime( ) {
	SoundPlay, %A_ScriptDir%\blob\nightchime.wav 
}