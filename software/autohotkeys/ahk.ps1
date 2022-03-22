$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils
###

$Startup = [Environment]::GetFolderPath('Startup')
$AHKDir = $PSScriptRoot
$PossibleScripts =Get-ChildItem -Path $AHKDir -Filter *.ahk

foreach ( $Name in $PossibleScripts) { 
    
    
    $StartupLink = Join-Path $Startup $Name
    $VersionedScript = $Name.FullName
    New-Item -Type HardLink -Path $StartupLink -Target $VersionedScript -Force 

}

$Executable = FindSingleInDir (GetParentDir) "MarbleScroll.exe"
Copy-Item -Path $Executable -Destination $Startup -Force
