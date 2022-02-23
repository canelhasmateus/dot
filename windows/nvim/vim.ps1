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




function Get-VimDir
{
    $Roaming = [Environment]::GetFolderPath("ApplicationData")
    $Appdata = Split-Path $Roaming -Parent
    $ConfigPath = Join-Path -Path $Appdata -ChildPath "/Local/nvim"

    return $ConfigPath
}
function Create-VimDir
{

    Log "Starting the creation of the vim directory."

    $ConfigPath = Get-VimDir
    Log "`tThe Nvim config directory was resolved as $ConfigPath"
    $ConfigExists = Test-Path $ConfigPath
    if ($ConfigExists)
    {
        Warn "`t`tThe Nvim config directory already exists."

    }
    else
    {
        New-Item -Type Directory -Path $ConfigPath
        Log "`t`tSince the Nvim config directory did not exist, it was created."

    }
}

function Link-InitVim
{


    $FileName = "init.vim"
    Log "Starting the process of linking the versioned $FileName configuration file."

    $ScriptDirectory = Resolve-Path $PSScriptRoot
    $ParentDirectory = Split-Path $ScriptDirectory -Parent
    Log "`tThe script directory was determined as $ScriptDirectory, with parent as $ParentDirectory"

    $PossibleScripts = Get-ChildItem -Path $ParentDirectory -Filter "$FileName" -Recurse
    if ($PossibleScripts.Count -gt 1)
    {
        Err "`t`tAn error occured. More than one candidate '$FileName' file was found inside $ParentDirectory"
        return
    }

    $InitScript = $PossibleScripts[0].FullName
    $ConfigPath = Get-VimDir
    $QualifiedConfigPath = Join-Path $ConfigPath "$FileName"

    Log "`tStarting the creation of an symbolic link: $QualifiedConfigPath -> $InitScript"

    $QualifiedExists = Test-Path $QualifiedConfigPath
    if ($QualifiedExists)
    {

        Warn "`t`tThe symbolic link path already exists, and won't be created."
        return
    }

    Try
    {
        New-Item -Type HardLink -Path $QualifiedConfigPath -Target $InitScript -ErrorAction Stop
        Log "`t`tCreation of the link succeeded."
    }
    catch [System.IO.IOException]
    {

        $Message = FullMessage $_.Exception
        Err "`t`tAn error occurred during the creation of the symbolic link: $Message"

    }


}
function Link-InitLua
{


    $FileName = "init.lua"
    Log "Starting the process of linking the versioned $FileName configuration file."
    $ScriptDirectory = Resolve-Path $PSScriptRoot
    $ParentDirectory = Split-Path $ScriptDirectory -Parent

    Log "`tThe script directory was determined as $ScriptDirectory, with parent as $ParentDirectory"

    $PossibleScripts = Get-ChildItem -Path $ParentDirectory -Filter "$FileName" -Recurse

    if ($PossibleScripts.Count -gt 1)
    {
        Err "`t`tAn error occured. More than one candidate '$FileName' file was found inside $ParentDirectory"
        return
    }

    $InitScript = $PossibleScripts[0].FullName
    $ConfigPath = Get-VimDir
    $QualifiedConfigPath = Join-Path $ConfigPath "$FileName"




    Log "`tStarting the creation of an symbolic link: $QualifiedConfigPath -> $InitScript"

    $QualifiedExists = Test-Path $QualifiedConfigPath
    if ($QualifiedExists)
    {

        Warn "`t`tThe symbolic link path already exists, and won't be created."
        return
    }


    Try
    {
        New-Item -Type HardLink -Path $QualifiedConfigPath -Target $InitScript -ErrorAction Stop
        Log "`t`tCreation of the link succeeded."
    }
    catch [System.IO.IOException]
    {

        $Message = FullMessage $_.Exception
        Err "`t`tAn error occurred during the creation of the symbolic link: $Message"

    }


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
Install-VimPlug