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
function Get-AlacrittyDir
{
    $Roaming = [Environment]::GetFolderPath("ApplicationData")
    $ConfigPath = Join-Path $Roaming "/alacritty"

    return $ConfigPath
}
function Create-AlacrittyDir
{

    Write-Host "Starting the creation of the Alacritty directory."

    $ConfigPath = Get-AlacrittyDir
    Write-Host "`tThe Alacritty config directory was resolved as $ConfigPath"
    $ConfigExists = Test-Path $ConfigPath
    if (!$ConfigExists)
    {
        New-Item -Type Directory -Path $ConfigPath
        Write-Host "`t`tSince the Alacritty config directory did not exist, it was created."

    }
    else
    {
        Write-Host "`t`tThe Alacritty config directory already exists."
    }
}

function Link-AlacrittyConfig
{

    $FileName = "alacritty.yml"
    Write-Host "Starting the process of linking the versioned $FileName configuration file."
    $ScriptDirectory = Resolve-Path $PSScriptRoot
    $ParentDirectory = Split-Path $ScriptDirectory -Parent

    Write-Host "`tThe script directory was determined as $ScriptDirectory, with parent as $ParentDirectory"

    $PossibleScripts = Get-ChildItem -Path $ParentDirectory -Filter $FileName -Recurse

    if ($PossibleScripts.Count -gt 1)
    {
        Write-Host "`t`tAn error occured. More than one candidate '$FileName' file was found inside $ParentDirectory"
        return
    }

    $InitScript = $PossibleScripts[0].FullName
    $ConfigPath = Get-AlacrittyDir
    $QualifiedConfigPath = Join-Path $ConfigPath $FileName

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


Create-AlacrittyDir
Link-AlacrittyConfig