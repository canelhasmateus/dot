
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



GetNextKey() 
{
  Input pressedKey, M L1 T2 B, {Escape}{Tab}{Backspace}
  return pressedKey
}

sendDesktopOrSwitchDesktop( desktopNumber ) 
{
  if GetKeyState("LAlt", "P") = 1
  {
    
    ; Todo: Send current window to another desktop.
  
  }
  else
  {
    switchDesktopByNumber( desktopNumber)
  }

}



GetBrowserUrl() 
{

	accData:= GetAccData() ; parameter: "A" (default), "WinTitle", "ahk_class IEFrame", "ahk_exe chrome.exe", etc.
    if ( accData ) {
      return accData.2
    }
}
