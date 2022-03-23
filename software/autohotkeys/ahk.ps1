$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils
###

$Startup = [Environment]::GetFolderPath('Startup')

$CanelhasScript = FindSingleInDir ( GetParentDir ) canelhas.ahk
$BatLauncher = Join-Path $Startup  "CanelhasLauncher.bat"

New-Item  $BatLauncher -Type File -Force
Set-Content $BatLauncher @"
@ECHO OFF 
start /B $CanelhasScript
"@


$Executable = FindSingleInDir (GetParentDir) "MarbleScroll.exe"
Copy-Item -Path $Executable -Destination $Startup -Force
