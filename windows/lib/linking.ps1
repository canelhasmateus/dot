function CreateDir {

    param([String] $Path,
        [String] $Description)

    $PathExists = Test-Path $Path
    if ($PathExists) {
        Write-Information "`t`tThe $Description directory already exists."

    }
    else {
        New-Item -Type Directory -Path $Path 
        Write-Information "`t`tSince the $Description directory did not exist, it was created."

    }


}

function CreateHardLink {


    param([String]$Source,
        [String]$Target )


    Write-Information "`tStarting the creation of an hardlink: $Source -> $Target" -ErrorAction Stop

    Try {

        New-Item -Type HardLink -Path $Source -Target $Target -ErrorAction Stop  -Force
        Write-Information "`t`tCreation of the link succeeded."
    }
    catch [System.IO.IOException] {

        $Message = FullMessage $_.Exception
        Write-Error "`t`tAn error occurred during the creation of the symbolic link: $Message"

    }

}

function CreateSymLink {


    param([String]$Source,
        [String]$Target)


    Write-Information "`tStarting the creation of an symlink: $Source -> $Target"

    $SourceExists = Test-Path $Source
    if ($SourceExists) {

        Write-Information "`t`tThe symlink path already exists, and won't be created."
        return
    }

    Try {
        New-Item -Type SymbolicLink -Path $Source -Target $Target -ErrorAction Stop -Force
        Write-Information "`t`tCreation of the symlink succeeded."
    }
    catch [System.IO.IOException] {

        $Message = FullMessage $_.Exception
        Write-Error "`t`tAn error occurred during the creation of the symlink $Message"

    }

}
function FindSingleInDir {

    param([String]$Haystack,
        [String]$Needle
    )


    $PossibleScripts = Get-ChildItem -Path $Haystack -Filter $Needle -Recurse
    if ($PossibleScripts.Count -gt 1) {
        Write-Error "`t`tAn error occured. More than one candidate '$Needle' was found inside $Haystack"
        return
    }
    if ($PossibleScripts.Count -eq 0) {
        Write-Error "An error occured. No candidate $Needle was found inside $Haystack"
    }
    return $PossibleScripts[0].FullName

}

function GetParentDir {

    $ScriptDirectory = Resolve-Path $PSScriptRoot
    $ParentDirectory = Split-Path $ScriptDirectory -Parent
    Write-Information "`tThe script directory was determined as $ScriptDirectory, with parent as $ParentDirectory"
    return $ParentDirectory
}
###

function CreateShortcut {
    param ( [string]$SourceLnk, [string]$DestinationPath )
    $WshShell = New-Object -comObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($SourceLnk)
    $Shortcut.TargetPath = $DestinationPath
    $Shortcut.Save()
}

function CoalesceBase( $Base , $Default ) {
    if ([string]::IsNullOrEmpty($Base)) {
            return $Default
    }
    return $Base

}
function Resolve-Base( $Base ) {
    try {
        return [Environment]::GetFolderPath($Base)
    }
    catch {
        try {
            return Invoke-Expression $Base
        }
        catch {
            return $Base
        }
        
    }
    
}
function Get-Target( $Root , $JsonObject ) {
    $BaseDir = Resolve-Base $JsonObject.targetRoot
    $BaseDir = CoalesceBase $BaseDir $Root
    return Join-Path $BaseDir $JsonObject.targetName
}


function Get-Destination($Root , $JsonObject) {
    $BaseDir = Resolve-Base $JsonObject.destinationRoot
    $BaseDir = CoalesceBase $BaseDir $Root
    return Join-Path $BaseDir $JsonObject.destinationName
}

function Get-Action( $JsonObject) {

    
    $a = switch ($jsonObject.type) {
        "hard" {  
            "HardLink"
        }
        "soft" {  
            "SymbolicLink"
        }
        "sym" {
            "SymbolicLink"
        }
        "junction" { 
            "Junction"
        }
        "copy" {
            "Copy"
        }
        "noop" {
            "Noop"
        }
        "shortcut" {
            "Shortcut"
        }
        Default { 
            "HardLink"
        }
    }

    return $a

}

function Run-StringCommand( $Command ) {
    

    
    if (![string]::IsNullOrEmpty($command) ) {
        $ExecPath = Join-Path $Root $command
        Write-Information "Runing $ExecPath"
        Invoke-Expression $ExecPath
    }

}


function Set-Mappings($Root , $MappingFile) {
    
    
    $contentFile = Join-Path $Root $MappingFile
    
    $mapping = Get-Content $contentFile | ConvertFrom-Json 
    
    foreach ($step in $mapping.steps) {
        
        $Target = Get-Target $Root $step
        $Destination = Get-Destination $Root $step
        $Action = Get-Action $step
        
        
        # todo  : Deal with force , runBefore and runLater;
        Run-StringCommand( $step.runBefore )
        switch ( $Action ) {
            "HardLink" {
                CreateHardLink $Destination $Target
            } 
            "SymbolicLink" {
                CreateSymLink $Destination $Target
            }
            "Junction" {
                CreateJunction $Destination $Target
            }
            "Copy" {
                Copy-Item -Path $Target $Destination 
            }
            "Shortcut" {        
                CreateShortcut $Destination $Target
            }
            "Noop" {
            
            }
        
        }
    
        Run-StringCommand( $step.runAfter )
    
    }
    
    
}
