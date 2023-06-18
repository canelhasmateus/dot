on run {input, parameters}
	tell application "Google Chrome" to activate
	tell application "System Events" to keystroke "n" using command down
	tell application "Google Chrome" to move to window with

--    set position of window "FaceTime" of application process "FaceTime" to {3269, 315}
	return input
end run