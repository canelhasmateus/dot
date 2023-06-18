tell application "iTerm2"
    set newWindow to (create window with default profile)
    tell current session of newWindow
        write text "/Users/mateus.canelhas/Desktop/pers/ormos/osx/scripts/blurb.sh"
    end tell
end tell