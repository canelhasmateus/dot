
$FontsModule      = Join-Path $PSScriptRoot "/lib/fonts.ps1"
$KeyBoardModule   = Join-Path $PSScriptRoot "/lib/keyboard.ps1"
$AppearanceModule = Join-Path $PSScriptRoot "/lib/appearance.ps1"
$ColemakArchive   = Join-Path $PSScriptRoot "/blob/Colemak.zip"   
. $FontsModule
. $KeyBoardModule
. $AppearanceModule


Set-KeyboardLayouts $ColemakArchive







