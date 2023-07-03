on run {input, parameters}
	tell application "iTerm"
		launch
		set newWindow to (create window with default profile command "~/.canelhasmateus/scripts/journal.sh")
	end tell
end run