$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils
###

$Name = "Canelhas.kws"
$VersionedScript = FindSingleInDir (GetParentDir) $Name
$Roaming = [Environment]::GetFolderPath('ApplicationData')
$KritaWorkspace = Join-Path $Roaming "/krita/workspaces"
$StartupLink = Join-Path $KritaWorkspace $Name
CreateHardLink $StartupLink $VersionedScript
