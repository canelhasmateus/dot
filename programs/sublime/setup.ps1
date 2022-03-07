$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils

$ROAMING = [Environment]::GetFolderPath("ApplicationData")
$SUBLIME_DIR = Join-Path $Roaming "\Sublime Text 3\Packages\User"
$SUBLIME_KEYBIND = Join-Path $SUBLIME_DIR "Default (Windows).sublime-keymap"

$VersionedScript = Resolve-Path "$PSScriptRoot/keybinds.json"

CreateHardLink $SUBLIME_KEYBIND $VersionedScript
