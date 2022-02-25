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

    $PathExists = Test-Path $Path
    if ($PathExists)
    {
        Warn "`t`tThe $Description directory already exists."

    }
    else
    {
        New-Item -Type Directory -Path $Path
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
function CreateSymLink
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
        New-Item -Type SymbolicLink -Path $Source -Target $Target -ErrorAction Stop
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
    if ($PossibleScripts.Count -eq 0)
    {
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