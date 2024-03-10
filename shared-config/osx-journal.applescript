tell application "System Events" to set frontBundleId to bundle identifier of first application process whose frontmost is true

tell application "iTerm"
	launch
	set newWindow to (create window with default profile command "~/.canelhasmateus/config/tmux-personal.sh")
	
	repeat while newWindow exists
		delay 0.01
	end repeat
	
end tell

tell application id frontBundleId to activate
