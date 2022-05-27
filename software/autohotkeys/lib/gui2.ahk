;array of arrays
levels 						:= []
levels["Associate"] 		:= ["Analysis", "Conference Call", "Data Copy"]
levels["Senior_Associate"] 	:= ["Conference Call", "Interviews"]
levels["Manager"] 			:= ["Conference Call", "Oversee Associate and Seniors"]
levels["Director"] 			:= ["Conference Call", "Project Management"]

;sample gui
gui, add, ComboBox,  vGUI_Levels 
gui, add, DropDownList, x10 y60 w100 vGUI_Tasks r5
gui, show, h100 w120
gosub GUI_Levels_Populate
return

;triggered when user changes the levels dropdownlist selection. 
;fills in the task for the selected 'level'
Update:
gui, Submit, noHide
GuiControl,, GUI_Tasks, |											;clear the tasks dropdownlist
for k, v in levels[GUI_Levels]		
	GuiControl,, GUI_Tasks, % v "|"									;populate the tasks dropdownlist
return

;fills the levels in the GUI_Levels dropdownlist when gui is created.
GUI_Levels_Populate:
for k, v in levels
	GuiControl,, GUI_Levels, %  k "|"
return

esc::
exitapp