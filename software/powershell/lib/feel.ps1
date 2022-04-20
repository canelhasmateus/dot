# Install-Module -Name PowerShellGet -Force
# Import-Module posh-git
# Import-Module -Name Terminal-Icons



Set-PSReadLineOption -EditMode Emacs
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -ContinuationPrompt ""
try {
    Set-PSReadLineOption -PredictionSource History -ErrorAction SilentlyContinue *> $null
}
catch { 
    
}

Set-PSReadlineOption -Color @{
    
    "Command"            = [ConsoleColor]::Red
    "Parameter"          = [ConsoleColor]::Yellow
    "Operator"           = [ConsoleColor]::Red
    "Variable"           = [ConsoleColor]::White
    "String"             = [ConsoleColor]::Green
    "Number"             = [ConsoleColor]::Blue
    "Type"               = [ConsoleColor]::Cyan
    "Comment"            = [ConsoleColor]::Gray
    # Todo:  Use RGB ; Customize the ones block below

    # "ContinuationPrompt" = [ConsoleColor]::White
    # "Emphasis"           = [ConsoleColor]::White
    
    # "Error"              = [ConsoleColor]::White
    # "Selection"          = [ConsoleColor]::White
    # "Default"            = [ConsoleColor]::White
    # "Keyword"            = [ConsoleColor]::White
    # "Member"             = [ConsoleColor]::White
    # "InlinePrediction"   = [ConsoleColor]::Gray

    # "ListPredictionColor"         = [ConsoleColor]::White
    # "ListPredictionSelectedColor" = [ConsoleColor]::White


}

$DefaultColors = (Get-Host).UI.RawUI
[void]@{
    # DefaultColors Possibilities
    BackgroundColor       = ""
    CursorPosition        = ""
    ForegroundColor       = ""
    MaxPhysicalWindowSize = ""
    MaxWindowSize         = ""
    WindowSize            = ""
    WindowPosition        = ""

}


# $DefaultColors.BackgroundColor = "#2B2B2B"


Set-PSReadLineKeyHandler -Function DeleteChar -Chord 'Ctrl+d'
Set-PSReadlineKeyHandler -Function MenuComplete -Chord 'Tab'
Set-PSReadlineKeyHandler -Function SelectAll -Chord 'Ctrl+a'

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




