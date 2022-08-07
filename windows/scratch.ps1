
$FontsModule      = Join-Path $PSScriptRoot "/lib/fonts.ps1"
$KeyBoardModule   = Join-Path $PSScriptRoot "/lib/keyboard.ps1"
$AppearanceModule = Join-Path $PSScriptRoot "/lib/appearance.ps1"
$ColemakArchive   = Join-Path $PSScriptRoot "/blob/Colemak.zip"   
. $FontsModule
. $KeyBoardModule
. $AppearanceModule


Set-KeyboardLayouts $ColemakArchive
$env:PATH = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
[AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
    $path = $_.Location
    if ($path) { 
        $name = Split-Path $path -Leaf
        Write-Host -ForegroundColor Yellow "`r`nRunning ngen.exe on '$name'"
        ngen.exe install $path /nologo
    }
}
