$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils
##

$FileName = "alacritty.yml"
$VersionedScript = Join-Path $PSScriptRoot $FileName

$Roaming = [Environment]::GetFolderPath("ApplicationData")
$ConfigPath = Join-Path $Roaming "/alacritty"

CreateDir $ConfigPath "Alacritty Dir"
CreateHardLink ( Join-Path $ConfigPath $FileName) $VersionedScript