$utils = Resolve-Path "$PSScriptRoot/../../module/dotUtils.ps1"
Import-Module $utils
###

function Get-VimDir
{
    $Roaming = [Environment]::GetFolderPath("ApplicationData")
    $Appdata = Split-Path $Roaming -Parent
    $ConfigPath = Join-Path -Path $Appdata -ChildPath "/Local/nvim"

    return $ConfigPath
}

function Create-VimDir
{
    $Description = "Nvim Config"
    Log "Starting the creation of the $Description directory."
    $ConfigPath = Get-VimDir
    Log "`tThe $Description directory was resolved as $ConfigPath"
    CreateDir $ConfigPath $Description


}

function Link-InitVim
{


    $FileName = "init.vim"
    $ConfigPath = Get-VimDir
    $DestinationPath = Join-Path $ConfigPath $FileName

    Log "Starting the process of linking the versioned $FileName configuration file."
    $ParentDirectory = GetParentDir
    $VersionedScript = FindSingleInDir  $ParentDirectory $FileName


    CreateHardLink $DestinationPath $VersionedScript


}
function Link-InitLua
{
    $FileName = "init.lua"
    $ConfigPath = Get-VimDir
    $DestinationPath = Join-Path $ConfigPath $FileName

    Log "Starting the process of linking the versioned $FileName configuration file."
    $ParentDirectory = GetParentDir
    $VersionedScript = FindSingleInDir  $ParentDirectory $FileName


    CreateHardLink $DestinationPath $VersionedScript

}

function Link-LuaDir
{


    $DirName = "lua"
    $ConfigPath = Get-VimDir
    $DestinationPath = Join-Path $ConfigPath $DirName

    Log "Starting the process of linking the versioned $DirName directory."
    $ParentDirectory = GetParentDir
    $JunctionedDir = FindSingleInDir $ParentDirectory $DirName

    CreateSymLink $DestinationPath $JunctionedDir

}


Create-VimDir
Link-InitLua
Link-LuaDir
