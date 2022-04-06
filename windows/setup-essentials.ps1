$Threading = Join-Path $PSScriptRoot "/lib/threading.ps1"
. $Threading
function Add-Path {

    param ( $INCLUDE )

    $OLDPATH = [System.Environment]::GetEnvironmentVariable('PATH', 'machine')
    $NEWPATH = "$OLDPATH;$INCLUDE"
    [Environment]::SetEnvironmentVariable("PATH", "$NEWPATH", "Machine")


}


function Add-FrillsJob {
    $DiagFile = Join-Path $PSScriptRoot "/blob/frills.diag"

    $JobOptions = New-ScheduledJobOption -RunElevated
    $StartupTrigger = New-JobTrigger -AtStartup
    $FrillsPath = Join-Path $PSScriptRoot "setup-frills.ps1"
    
    $Script = { param( $Script , $Log )

        Remove-Item -Path $log -Force
        Invoke-Expression "$Script -Verbose -Debug *> $log"
        Unregister-ScheduledJob -Name "setup-frills"
        Get-ScheduledJob  
    }

    Unregister-ScheduledJob -Name "setup-frills"
    Register-ScheduledJob -Name "setup-frills" -Trigger $StartupTrigger  -ScheduledJobOption  $JobOptions -ScriptBlock $Script -ArgumentList @($FrillsPath , $DiagFile )

}

function Set-Looks {
        
    
    $AppearanceModule = Join-Path $PSScriptRoot "/lib/appearance.ps1"
    . $AppearanceModule
    
    Set-AppearanceExplorer
    Set-AppearanceTaskbar
    Set-AppearanceSystem

    Get-ChildItem -Path $PSScriptRoot -Recurse -Include *.jpg, *.png  | ForEach-Object { 
        Set-AppearanceWallpaper -Image  $_ 
    }
    
    displayswitch.exe /extend 
    
    #
    #
    #

    $RegistryModule = Join-Path $PSScriptRoot "/lib/registry.ps1"
    . $RegistryModule
    
    # $Changes = @(
    #     @{
    #         Path  = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PowerShell.exe"
    #         Key   = ""
    #         Value = '%ProgramFiles%\Alacritty\a.bat'
    #         Kind  = "ExpandString"
    #     }
    # )
    # Add-Registry $Changes
    
    
}

function Set-Region {
    
    $KeyBoardModule = Join-Path $PSScriptRoot "/lib/keyboard.ps1"
    .$KeyBoardModule

    
    $ColemakArchive = Join-Path $PSScriptRoot "\blob\Colemak.zip"
    Install-Colemak $ColemakArchive
    
    
    Set-KeyboardLayouts
    Set-TimeZone -Name 'E. South America Standard Time'

}
function Add-Choco {

    
    $ChocoUrl = 'https://community.chocolatey.org/install.ps1'
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    Invoke-RestMethod -Uri $ChocoUrl | Invoke-Expression    

    $Installs = @(  
        "7zip",
        "autohotkey",        
        "git",
        "sublimetext4",
        "win-vind",
        "vscode"
    ) | ForEach-Object { 
    
        $Script = { 
            param( $name) 
            choco install $name -y 
        } 

        $Parameter = @{
            name = $_
        }

        return Start-Background $Script $Parameter 
    }
    
    
    Add-Path "C:\Program Files\Sublime Text";

    return $Installs
}
function Add-WSL1 {
    

    
    $Script = { param( $WSLModule )
        . $WSLModule
        InstallWSL
    }
    $Parameter = @{ 
        WSLModule = Join-Path $PSScriptRoot "/lib/wsl.ps1"
    }

    return Start-Background $Script $Parameter 
    
}
function Add-Font {

    $Script = { param( $FontsModule )
     
        .$FontsModule
        Add-NerdFonts     
    }  
    
    $Parameters = @{ 
        FontsModule = Join-Path $PSScriptRoot "/lib/fonts.ps1"
    }

    
    return Start-Background $Script $Parameters
}
function Add-Links {

    $LinksModule = Join-Path $PSScriptRoot "/lib/linking.ps1"
    .$LinksModule


    
    $Root = Split-Path $PSScriptRoot -Parent
    
    $MappingFile = "/windows/blob/mapping.json"
    Set-Mappings $Root $MappingFile
        

}

function Optimize-Bloat {

    $TuningModule = Join-Path $PSScriptRoot "/lib/tuning.ps1"
    . $TuningModule

    
    Optimize-Services
    Optimize-AppxPackages
    Optimize-Privacy
    Optimize-NetworkTraffic
    Optimize-Others    
    Optimize-WindowsDefender

    #$Reg = Join-Path $PSScriptRoot "lib/ram.reg"
    #reg import $Reg 
    
    
}
#
#
#
#
#

$FontJob = Add-Font
$Installations = Add-Choco
$WSL = Add-WSL1

Set-Looks
Add-FrillsJob
Set-Region
Optimize-Bloat

Wait-Background @( 
    $Installations  
    $FontJob 
    $WSL
)
Add-Links



Restart-Computer;
