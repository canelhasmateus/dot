$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils
###

$Name = "canelhas.ahk"
$VersionedScript = FindSingleInDir (GetParentDir) $Name
$Startup = [Environment]::GetFolderPath('Startup')
$StartupLink = Join-Path $Startup $Name
CreateHardLink $StartupLink $VersionedScript



$Name = "workspaces.ahk"
$VersionedScript = FindSingleInDir (GetParentDir) $Name
$Startup = [Environment]::GetFolderPath('Startup')
$StartupLink = Join-Path $Startup $Name
CreateHardLink $StartupLink $VersionedScript
