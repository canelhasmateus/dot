function FullMessage
{

    param([Exception] $e)

    $msg = $e.Message
    while ($e.InnerException)
    {
        $e = $e.InnerException
        $msg += "`n" + $e.Message
    }

    return $msg

}

function Log
{

    param([String] $message)
    Write-Host $message
}

function Warn
{
    param([String] $message)
    Write-Host $message -ForegroundColor Yellow
}
function Err
{
    param([String] $message)
    Write-Host $message -ForegroundColor Red

}



function CreateDir
{

    param([String] $Path,
        [String] $Description)

    $ConfigExists = Test-Path $ConfigPath
    if ($ConfigExists)
    {
        Warn "`t`tThe $Description directory already exists."

    }
    else
    {
        New-Item -Type Directory -Path $ConfigPath
        Log "`t`tSince the $Description directory did not exist, it was created."

    }


}


function CreateHardLink
{


    param([String]$Source,
        [String]$Target)


    Log "`tStarting the creation of an hardlink: $DestinationPath -> $VersionedScript"

    $SourceExists = Test-Path $Source
    if ($SourceExists)
    {

        Warn "`t`tThe symbolic link path already exists, and won't be created."
        return
    }

    Try
    {
        New-Item -Type HardLink -Path $Source -Target $Target -ErrorAction Stop
        Log "`t`tCreation of the link succeeded."
    }
    catch [System.IO.IOException]
    {

        $Message = FullMessage $_.Exception
        Err "`t`tAn error occurred during the creation of the symbolic link: $Message"

    }

}
function CreateJunction
{


    param([String]$Source,
        [String]$Target)


    Log "`tStarting the creation of an junction: $Source -> $Target"

    $SourceExists = Test-Path $Source
    if ($SourceExists)
    {

        Warn "`t`tThe junction path already exists, and won't be created."
        return
    }

    Try
    {
        New-Item -Type HardLink -Path $Source -Target $Target -ErrorAction Stop
        Log "`t`tCreation of the Junction succeeded."
    }
    catch [System.IO.IOException]
    {

        $Message = FullMessage $_.Exception
        Err "`t`tAn error occurred during the creation of the junction: $Message"

    }

}

function FindSingleInDir
{

    param([String]$Haystack,
        [String]$Needle
    )


    $PossibleScripts = Get-ChildItem -Path $Haystack -Filter $Needle -Recurse
    if ($PossibleScripts.Count -gt 1)
    {
        Err "`t`tAn error occured. More than one candidate '$Needle' was found inside $Haystack"
        return
    }
    if ($PossibleScripts.Count -eq 0) {
        Err "An error occured. No candidate $Needle was found inside $Haystack"
    }
    return $PossibleScripts[0].FullName

}

function GetParentDir
{

    $ScriptDirectory = Resolve-Path $PSScriptRoot
    $ParentDirectory = Split-Path $ScriptDirectory -Parent
    Log "`tThe script directory was determined as $ScriptDirectory, with parent as $ParentDirectory"
    return $ParentDirectory
}
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

    CreateJunction $DestinationPath $JunctionedDir

}

function Install-VimPlug
{
    $VimDirectory = Get-VimDir
    $AutoLoadDirectory = Join-Path $VimDirectory "autoload"

    $DirectoryExists = Test-Path $AutoLoadDirectory

    if ($DirectoryExists)
    {
        Warn "Vim Plug Directory '$AutoLoadDirectory' already Exists."
    }
    else
    {
        Log "Vim Plug Directory '$AutoLoadDirectory' does not exists, and will be created."

        New-Item -Type Directory $AutoLoadDirectory

    }

    $GitPlug = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    $PlugFile = Join-Path $AutoLoadDirectory "plug.vim"
    $PlugExists = Test-Path $PlugFile

    if ($PlugExists)
    {
        Warn "Vim Plug file '$PlugFile' already Exists."
    }
    else
    {
        Log "Vim Plug file '$AutoLoadDirectory' does not exists, and will be downloaded."
        Invoke-RestMethod -Uri $GitPlug -OutFile $PlugFile

    }


}

Create-VimDir
Link-InitVim
Link-InitLua
Link-LuaDir
Install-VimPlug
