function FullMessage()
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
function Get-VimDir
{
    $Roaming = [Environment]::GetFolderPath("ApplicationData")
    $Appdata = Split-Path $Roaming -Parent
    $ConfigPath = Join-Path -Path $Appdata -ChildPath "/Local/nvim"

    return $ConfigPath
}
function Create-VimDir
{

    Write-Host "Starting the creation of the vim directory."

    $ConfigPath = Get-VimDir
    Write-Host "`tThe Nvim config directory was resolved as $ConfigPath"
    $ConfigExists = Test-Path $ConfigPath
    if (!$ConfigExists)
    {
        New-Item -Type Directory -Path $ConfigPath
        Write-Host "`t`tSince the Nvim config directory did not exist, it was created."

    }
    else
    {
        Write-Host "`t`tThe Nvim config directory already exists."
    }
}

function Link-VimConfig
{


    Write-Host "Starting the process of linking the versioned init.vim configuration file."
    $ScriptDirectory = Resolve-Path $PSScriptRoot
    $ParentDirectory = Split-Path $ScriptDirectory -Parent

    Write-Host "`tThe script directory was determined as $ScriptDirectory, with parent as $ParentDirectory"

    $PossibleScripts = Get-ChildItem -Path $ParentDirectory -Filter "init.vim" -Recurse

    if ($PossibleScripts.Length -gt 1)
    {
        Write-Host "`t`tAn error occured. More than one candidate 'init.vim' file was found inside $ParentDirectory"
        return
    }

    $InitScript = $PossibleScripts[0].FullName
    $ConfigPath = Get-VimDir
    $QualifiedConfigPath = Join-Path $ConfigPath "init.vim"

    Write-Host "`tStarting the creation of an symbolic link: $QualifiedConfigPath -> $InitScript"

    Try
    {
        New-Item -Type HardLink -Path $QualifiedConfigPath -Target $InitScript -ErrorAction Stop
        Write-Host "`t`tCreation of the link succeeded."
    }
    catch [System.IO.IOException]
    {

        $Message = FullMessage $_.Exception
        Write-Host "`t`tAn error occurred during the creation of the symbolic link: $Message"

    }


}

function Install-VimPlug
{
    $VimDirectory = Get-VimDir
    $AutoLoadDirectory = Join-Path $VimDirectory "autoload"
    New-Item -Type Directory $AutoLoadDirectory

    $GitPlug = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    $PlugFile = Join-Path $AutoLoadDirectory "plug.vim"

    Invoke-RestMethod -Uri $GitPlug -OutFile $PlugFile

}

Create-VimDir
Link-VimConfig
Install-VimPlug