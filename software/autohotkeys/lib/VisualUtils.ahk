
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


AutoCompleteComboBox( prompt , options ) {
    Global ChosenOption

    ChosenOption := ""
    Gui, 2:+LastFound
    GuiHWND := WinExist() ;--get handle to this gui..
    
    
    Gui, 2:Add , Text , , %prompt%
    Gui, 2:Add , ComboBox, vChosenOption gCbAutoComplete
    Gui, 2:Add , Button, gButtonComplete, OK
    Gui, 2:Show

    for k, v in options {        
        GuiControl,2:, ChosenOption, % v "|"
    }

    WinWaitClose, ahk_id %GuiHWND% ;--waiting for 'gui to close
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


a := AutoCompleteComboBox("A" , ["Red" , "Green" , "Blue"])
MsgBox %a%