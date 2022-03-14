$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils

$ROAMING = [Environment]::GetFolderPath("ApplicationData")
$SUBLIME_DIR = Join-Path $Roaming "\Sublime Text 3\Packages\User"
$SUBLIME_KEYBIND = Join-Path $SUBLIME_DIR "Default (Windows).sublime-keymap"

$VersionedScript = Resolve-Path "$PSScriptRoot/keybinds.json"


CreateHardLink $SUBLIME_KEYBIND $VersionedScript


$SUBLIME_AMOUNT = Join-Path $SUBLIME_DIR "move_amount.py"
$VersionedAmount = Resolve-Path "$PSScriptRoot/move_amount.py"

CreateHardLink $SUBLIME_AMOUNT $VersionedAmount

$SUBLIME_SELECTION = Join-Path $SUBLIME_DIR "clear_selection.py"
$VersionedSelection = Resolve-Path "$PSScriptRoot/clear_selection.py"

CreateHardLink $SUBLIME_SELECTION $VersionedSelection
