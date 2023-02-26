using namespace System.Management.Automation
using namespace System.Management.Automation.Language



Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -ContinuationPrompt ""
try {
    Set-PSReadLineOption -PredictionSource History *> $null
}
catch {

}

Set-PSReadlineOption -Color @{
    
    "Command"   = [ConsoleColor]::Red
    "Parameter" = [ConsoleColor]::Yellow
    "Operator"  = [ConsoleColor]::Red
    "Variable"  = [ConsoleColor]::White
    "String"    = [ConsoleColor]::Green
    "Number"    = [ConsoleColor]::Blue
    "Type"      = [ConsoleColor]::Cyan
    "Comment"   = [ConsoleColor]::Gray

    # "ContinuationPrompt" = [ConsoleColor]::White
    # "Emphasis"           = [ConsoleColor]::White
    # "Error"              = [ConsoleColor]::White
    # "Selection"          = [ConsoleColor]::White
    # "Default"            = [ConsoleColor]::White
    # "Keyword"            = [ConsoleColor]::White
    # "Member"             = [ConsoleColor]::White
    # "InlinePrediction" = [ConsoleColor]::Gray
    # "ListPredictionColor"         = [ConsoleColor]::White
    # "ListPredictionSelectedColor" = [ConsoleColor]::White
}


Set-PSReadlineKeyHandler -Function TabCompleteNext -Chord 'Tab'
Set-PSReadlineKeyHandler -Function TabCompletePrevious -Chord 'Shift+Tab'
#
Set-PSReadlineKeyHandler -Function Paste -Chord 'Ctrl+v'
Set-PSReadlineKeyHandler -Function Undo -Chord 'Ctrl+z'
Set-PSReadlineKeyHandler -Function SelectAll -Chord 'Ctrl+a'
#
Set-PSReadlineKeyHandler -Function SelectLine -Chord 'Ctrl+Shift+End'
Set-PSReadlineKeyHandler -Function SelectLine -Chord 'Shift+End'
Set-PSReadlineKeyHandler -Function SelectForwardWord -Chord 'Ctrl+Shift+RightArrow'
Set-PSReadlineKeyHandler -Function EndOfLine -Chord 'End'
Set-PSReadlineKeyHandler -Function EndOfLine -Chord 'Ctrl+End'
Set-PSReadlineKeyHandler -Function ForwardWord -Chord 'Ctrl+RightArrow'

Set-PSReadlineKeyHandler -Function SelectBackwardsLine -Chord 'Ctrl+Shift+Home'
Set-PSReadlineKeyHandler -Function SelectBackwardsLine -Chord 'Shift+Home'
Set-PSReadlineKeyHandler -Function SelectBackwardWord -Chord 'Ctrl+Shift+LeftArrow'
Set-PSReadlineKeyHandler -Function BeginningOfLine -Chord 'Home'
Set-PSReadlineKeyHandler -Function BeginningOfLine -Chord 'Ctrl+Home'
Set-PSReadlineKeyHandler -Function BackwardDeleteWord -Chord 'Ctrl+Backspace'
Set-PSReadlineKeyHandler -Function BackwardWord -Chord 'Ctrl+LeftArrow'
#

Set-PSReadlineKeyHandler -Function ShowKeyBindings -Chord 'Ctrl+s'
# Set-PSReadlineKeyHandler -Function ScrollDisplayUp -Chord 'Ctrl+Alt+UpArrow'
# Set-PSReadlineKeyHandler -Function ScrollDisplayUpLine -Chord 'Alt+UpArrow'

# Set-PSReadlineKeyHandler -Function ScrollDisplayDown -Chord 'Ctrl+Alt+DownArrow'
# Set-PSReadlineKeyHandler -Function ScrollDisplayDownLine -Chord 'Alt+DownArrow'

if ($currentVersion -gt 5) {
    try {
        Set-PSReadLineOption -PredictionViewStyle InlineView *> $null
        Set-PSReadlineKeyHandler -Function SwitchPredictionView -Chord 'Alt+e,Tab'
    }
    catch {
        
    }

}
#

# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute.  It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
# 
# Set-PSReadLineKeyHandler -Lockpick Alt+w `
#     -BriefDescription SaveInHistory `
#     -LongDescription "Save current line in history but do not execute" `
#     -ScriptBlock {
#     param($key, $arg)

#     $line = $null
#     $cursor = $null
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
#     [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
#     [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
# }


# Set-PSReadLineKeyHandler -Chord Ctrl+V `
#     -BriefDescription PasteAsHereString `
#     -LongDescription "Paste the clipboard text as a here string" `
#     -ScriptBlock {
#     param($key, $arg)
#     Add-Type -Assembly PresentationCore
#     if ([System.Windows.Clipboard]::ContainsText()) {
#         # Get clipboard text - remove trailing spaces, convert \r\n to \n, and remove the final \n.
#         $text = ([System.Windows.Clipboard]::GetText() -replace "\p{Zs}*`r?`n", "`n").TrimEnd()
#         [Microsoft.PowerShell.PSConsoleReadLine]::Insert("@'`n$text`n'@")
#     }
#     else {
#         [Microsoft.PowerShell.PSConsoleReadLine]::Ding()
#     }
# }