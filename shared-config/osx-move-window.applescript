
on run {input, parameters}
	
	tell application "System Events"
		
		tell (the first application process whose frontmost is true)
			set currentWindow to the 1st window whose value of attribute "AXMain" is true
			
			set {x, y} to position of the currentWindow
			if y ≥ 0 then
				set wantedPosition to  {0, -768}
				set wantedBounds to {1310, 768}
			else
				set wantedPosition to {0, 0 }
				set wantedBounds to {1728, 1079} 
			end if
	
			set position of currentWindow to wantedPosition
			set { x , y } to wantedBounds
			click at { x + 1  , y + 100 }
			delay 0.01
			click at { x + 1  , y + 100 }
		end tell
		
	end tell
	
end run

