using namespace System.Management.Automation
using namespace System.Management.Automation.Language

Set-PSReadlineOption -Color @{
    
    "Command"          = [ConsoleColor]::Red
    "Parameter"        = [ConsoleColor]::Yellow
    "Operator"         = [ConsoleColor]::Red
    "Variable"         = [ConsoleColor]::White
    "String"           = [ConsoleColor]::Green
    "Number"           = [ConsoleColor]::Blue
    "Type"             = [ConsoleColor]::Cyan
    "Comment"          = [ConsoleColor]::Gray

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

# $DefaultColors = (Get-Host).UI.RawUI
# [void]@{
#     # DefaultColors Possibilities
#     BackgroundColor       = ""
#     CursorPosition        = ""
#     ForegroundColor       = ""
#     MaxPhysicalWindowSize = ""
#     MaxWindowSize         = ""
#     WindowSize            = ""
#     WindowPosition        = ""
# }


# # # 





# Install-Module -Name PowerShellGet -Force
# Import-Module posh-git
# Import-Module -Name Terminal-Icons

# Dracula Prompt Configuration
# $GitPromptSettings.DefaultPromptPrefix.Text = "$([char]0x2192) " # arrow unicode symbol
# $GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Green
# $GitPromptSettings.DefaultPromptPath.ForegroundColor = [ConsoleColor]::Cyan
# $GitPromptSettings.DefaultPromptSuffix.Text = "$([char]0x203A) " # chevron unicode symbol
# $GitPromptSettings.DefaultPromptSuffix.ForegroundColor = [ConsoleColor]::Magenta
# Dracula Git Status Configuration
# $GitPromptSettings.BeforeStatus.ForegroundColor = [ConsoleColor]::Blue
# $GitPromptSettings.BranchColor.ForegroundColor = [ConsoleColor]::Blue
# $GitPromptSettings.AfterStatus.ForegroundColor = [ConsoleColor]::Blue

# Import-Module PSFzf
# Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'


# Set-PSReadLineOption -PredictionViewStyle ListView 

Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -ContinuationPrompt ""
try {
    Set-PSReadLineOption -PredictionSource History *> $null
}
catch {

}


Set-PSReadlineKeyHandler -Function MenuComplete -Chord 'Tab'
Set-PSReadlineKeyHandler -Function SelectAll -Chord 'Ctrl+a'
Set-PSReadlineKeyHandler -Function Paste -Chord 'Ctrl+v'
Set-PSReadlineKeyHandler -Function BackwardWord -Chord 'Ctrl+LeftArrow'
Set-PSReadlineKeyHandler -Function ForwardWord -Chord 'Ctrl+RightArrow'
Set-PSReadlineKeyHandler -Function BackwardDeleteWord -Chord 'Ctrl+Backspace'
Set-PSReadLineKeyHandler -Function HistorySearchBackward -Key UpArrow 
Set-PSReadLineKeyHandler -Function HistorySearchForward -Key DownArrow 


Set-PSReadLineKeyHandler -Key '"', "'" `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
    -ScriptBlock {
    param($key, $arg)
# 
    $quote = $key.KeyChar
# 
    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
# 
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
# 
    # If text is selected, just quote it without any smarts
    if ($selectionStart -ne -1) {
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $quote + $line.SubString($selectionStart, $selectionLength) + $quote)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
        return
    }
# 
    $ast = $null
    $tokens = $null
    $parseErrors = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$ast, [ref]$tokens, [ref]$parseErrors, [ref]$null)
# 
    function FindToken {
        param($tokens, $cursor)
# 
        foreach ($token in $tokens) {
            if ($cursor -lt $token.Extent.StartOffset) { continue }
            if ($cursor -lt $token.Extent.EndOffset) {
                $result = $token
                $token = $token -as [StringExpandableToken]
                if ($token) {
                    $nested = FindToken $token.NestedTokens $cursor
                    if ($nested) { $result = $nested }
                }
# 
                return $result
            }
        }
        return $null
    }
# 
    $token = FindToken $tokens $cursor
# 
    # If we're on or inside a **quoted** string token (so not generic), we need to be smarter
    if ($token -is [StringToken] -and $token.Kind -ne [TokenKind]::Generic) {
        # If we're at the start of the string, assume we're inserting a new string
        if ($token.Extent.StartOffset -eq $cursor) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote ")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }
# 
        # If we're at the end of the string, move over the closing quote if present.
        if ($token.Extent.EndOffset -eq ($cursor + 1) -and $line[$cursor] -eq $quote) {
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
            return
        }
    }
# 
    if ($null -eq $token -or
        $token.Kind -eq [TokenKind]::RParen -or $token.Kind -eq [TokenKind]::RCurly -or $token.Kind -eq [TokenKind]::RBracket) {
        if ($line[0..$cursor].Where{ $_ -eq $quote }.Count % 2 -eq 1) {
            # Odd number of quotes before the cursor, insert a single quote
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
        }
        else {
            # Insert matching quotes, move cursor to be in between the quotes
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$quote$quote")
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
        }
        return
    }
# 
    # If cursor is at the start of a token, enclose it in quotes.
    if ($token.Extent.StartOffset -eq $cursor) {
        if ($token.Kind -eq [TokenKind]::Generic -or $token.Kind -eq [TokenKind]::Identifier -or 
            $token.Kind -eq [TokenKind]::Variable -or $token.TokenFlags.hasFlag([TokenFlags]::Keyword)) {
            $end = $token.Extent.EndOffset
            $len = $end - $cursor
            [Microsoft.PowerShell.PSConsoleReadLine]::Replace($cursor, $len, $quote + $line.SubString($cursor, $len) + $quote)
            [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($end + 2)
            return
        }
    }
# 
    # We failed to be smart, so just insert a single quote
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert($quote)
}

Set-PSReadLineKeyHandler -Key '(', '{', '[' `
    -BriefDescription InsertPairedBraces `
    -LongDescription "Insert matching braces" `
    -ScriptBlock {
    param($key, $arg)
# 
    $closeChar = switch ($key.KeyChar) {
        <#case#> '(' { [char]')'; break }
        <#case#> '{' { [char]'}'; break }
        <#case#> '[' { [char]']'; break }
    }
# 
    $selectionStart = $null
    $selectionLength = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetSelectionState([ref]$selectionStart, [ref]$selectionLength)
# 
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    # 
    if ($selectionStart -ne -1) {
        # Text is selected, wrap it in brackets
        [Microsoft.PowerShell.PSConsoleReadLine]::Replace($selectionStart, $selectionLength, $key.KeyChar + $line.SubString($selectionStart, $selectionLength) + $closeChar)
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($selectionStart + $selectionLength + 2)
    }
    else {
        # No text is selected, insert a pair
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)$closeChar")
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
}

Set-PSReadLineKeyHandler -Key ')', ']', '}' `
    -BriefDescription SmartCloseBraces `
    -LongDescription "Insert closing brace or skip" `
    -ScriptBlock {
    param($key, $arg)
# 
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
# 
    if ($line[$cursor] -eq $key.KeyChar) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)")
    }
}

Set-PSReadLineKeyHandler -Key Backspace `
    -BriefDescription SmartBackspace `
    -LongDescription "Delete previous character or matching quotes/parens/braces" `
    -ScriptBlock {
    param($key, $arg)
# 
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
# 
    if ($cursor -gt 0) {
        $toMatch = $null
        if ($cursor -lt $line.Length) {
            switch ($line[$cursor]) {
                <#case#> '"' { $toMatch = '"'; break }
                <#case#> "'" { $toMatch = "'"; break }
                <#case#> ')' { $toMatch = '('; break }
                <#case#> ']' { $toMatch = '['; break }
                <#case#> '}' { $toMatch = '{'; break }
            }
        }
# 
        if ($toMatch -ne $null -and $line[$cursor - 1] -eq $toMatch) {
            [Microsoft.PowerShell.PSConsoleReadLine]::Delete($cursor - 1, 2)
        }
        else {
            [Microsoft.PowerShell.PSConsoleReadLine]::BackwardDeleteChar($key, $arg)
        }
    }
}
# 

# Sometimes you enter a command but realize you forgot to do something else first.
# This binding will let you save that command in the history so you can recall it,
# but it doesn't actually execute.  It also clears the line with RevertLine so the
# undo stack is reset - though redo will still reconstruct the command line.
# 
Set-PSReadLineKeyHandler -Key Alt+w `
    -BriefDescription SaveInHistory `
    -LongDescription "Save current line in history but do not execute" `
    -ScriptBlock {
    param($key, $arg)
# 
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    [Microsoft.PowerShell.PSConsoleReadLine]::AddToHistory($line)
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
}

# Insert text from the clipboard as a here string
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
