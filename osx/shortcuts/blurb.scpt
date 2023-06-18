tell application "iTerm2"
    set newWindow to (create window with default profile)
    tell current session of newWindow
        write text "/./blurb.sh"
    end tell
end tell