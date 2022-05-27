#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%



Gui, Add, Text,, What to do?
Gui, Add, DropdownList,vwhattodo, Nothing || Nothing at all | Just nothing 
Gui, Add, Text,, Other:
Gui, Add, Edit, vtext,
Gui, Add, Button,gOk wp,Ok
Gui, Show,,FlowTime
return

Ok:
Gui,Submit,Nohide ;Remove Nohide if you want the GUI to hide.
MsgBox, 64, %A_ScriptName%, You want to do '%whattodo%' with '%text%'
return


