$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils
###

$VersionedScript = FindSingleInDir (GetParentDir) ".vindrc"
$ExpectedLocation = "C:\Users\Mateus\.win-vind\.vindrc"
CreateHardLink $ExpectedLocation $VersionedScript

