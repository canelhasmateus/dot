$RegistryModule = Join-Path $PSScriptRoot "/registry.ps1"
. $RegistryModule


function Set-AppearanceExplorer {

    # "This Computer"-Button starts the explorer on the following path:
    #   LaunchTo    Value   Description
    #               1       Computer (Harddrives, Network, etc.)
    #               2       Fast Access
    #               3       Downloads (The Download-Folder)

    Write-Information "Setting up appreance of Explorer"
    
    $Explorer = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
    $Advanced = "$Explorer\Advanced"
    
    $Changes = @( 
        @{
            Path  = $Explorer
            Key   = "ShowRecent"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = $Explorer
            Key   = "ShowFrequent"
            Value = 0
            Kind  = "dword"
        }
        #
        @{
            Path  = $Advanced
            Key   = "LaunchTo"
            Value = 1
            Kind  = "dword"
        }
        @{
            Path  = $Advanced
            Key   = "ShowTaskViewButton"
            Value = 0
            Kind  = "dword"
        }
        
        @{ 
            Path  = $Advanced
            Key   = "TaskbarEnabled"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = $Advanced
            Key   = "HideFileExt"
            Value = 0
            Kind  = "dword"
        }
        @{ 
            Path  = "$Advanced\People" 
            Key   = "PeopleBand"
            Value = 0
            Kind  = "dword"
        }

    )
    
    Add-Registry $Changes
    
}

function Set-AppearanceTaskbar {

    
    $CurrentVersion = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    $WindowsPolicies = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows"
    
    $CurrentUser = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion"    
    $ContentDeliveryManager = "$CurrentUser\ContentDeliveryManager"
    $WindowsSearch = "$WindowsPolicies\Windows Search"
    Write-Information "Setting Appearance of the taskbar."
    
    $Changes = @(
        
        @{
            Path  = "$CurrentUser\AppHost"
            Key   = "EnableWebContentEvaluation"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$CurrentUser\Search"
            Key   = "BingSearchEnabled"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$CurrentUser\Search"
            Key   = "SearchboxTaskbarMode"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$CurrentUser\Feeds"
            Key   = "ShellFeedsTaskbarViewMode"
            Value = 1
            Kind  = "dword"
        }
        
        @{
            Path  = "$ContentDeliveryManager"
            Key   = "SystemPaneSuggestionsEnabled"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$ContentDeliveryManager"
            Key   = "PreInstalledAppsEnabled"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$ContentDeliveryManager"
            Key   = "OemPreInstalledAppsEnabled"
            Value = 0
            Kind  = "dword"
        }


        @{
            Path  = "$WindowsPolicies\Windows Feeds"
            Key   = "EnableFeeds"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$WindowsPolicies\System"
            Key   = "EnableActivityFeed"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$WindowsSearch"
            Key   = "AllowCortana"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$WindowsSearch"
            Key   = "DisableWebSearch"
            Value = 1
            Kind  = "dword"
        }
        @{
            Path  = "$CurrentVersion\MTCUVC"
            Key   = "EnableMtcUvc"
            Value = 0
            Kind  = "dword"
        }
        
        
    ) 
    
    Add-Registry $Changes
    Set-WindowsSearchSetting -EnableWebResultsSetting $false

}


function Set-AppearanceSystem {
    
    
    $CurrentVersion = "HKEY_CURRENT_USER\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion"
    $LocalMachine = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion"
    $Personalize = "$LocalMachine\Themes\Personalize"
    $Changes = @(
        @{
            Path  = "$CurrentVersion\PushNotifications"
            Key   = "NoTileApplicationNotification"
            Value = 1
            Kind  = "dword"
        }
        @{
            Path  = "$Personalize"
            Key   = "AppsUseLightTheme"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$Personalize"
            Key   = "SystemUsesLightTheme"
            Value = 0
            Kind  = "dword"
        }
        @{
            Path  = "$Personalize"
            Key   = "ColorPrevalence"
            Value = 1
            Kind  = "dword"
        }



    )

    Add-Registry $Changes
    
    
}
function Set-AppearanceWallPaper($Image) {
  
    Add-Type -TypeDefinition @" 
using System; 
using System.Runtime.InteropServices;
  
public class Params
{ 
    [DllImport("User32.dll",CharSet=CharSet.Unicode)] 
    public static extern int SystemParametersInfo (Int32 uAction, 
                                                   Int32 uParam, 
                                                   String lpvParam, 
                                                   Int32 fuWinIni);
}
"@ 
  
    $SPI_SETDESKWALLPAPER = 0x0014
    $UpdateIniFile = 0x01
    $SendChangeEvent = 0x02
  
    $fWinIni = $UpdateIniFile -bor $SendChangeEvent
  
    [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
 
}

function Set-AppearanceMenu {
    # https://superuser.com/a/1442733


    $START_MENU_LAYOUT = @"
<LayoutModificationTemplate xmlns:defaultlayout="http://schemas.microsoft.com/Start/2014/FullDefaultLayout" xmlns:start="http://schemas.microsoft.com/Start/2014/StartLayout" Version="1" xmlns:taskbar="http://schemas.microsoft.com/Start/2014/TaskbarLayout" xmlns="http://schemas.microsoft.com/Start/2014/LayoutModification">
    <LayoutOptions StartTileGroupCellWidth="6" />
    <DefaultLayoutOverride>
        <StartLayoutCollection>
            <defaultlayout:StartLayout GroupCellWidth="6" />
        </StartLayoutCollection>
    </DefaultLayoutOverride>
</LayoutModificationTemplate>
"@

    $layoutFile = "C:\Windows\StartMenuLayout.xml"

    #Delete layout file if it already exists
    If (Test-Path $layoutFile) {
        Remove-Item $layoutFile
    }

    #Creates the blank layout file
    $START_MENU_LAYOUT | Out-File $layoutFile -Encoding ASCII

    $regAliases = @("HKLM", "HKCU")

    #Assign the start layout and force it to apply with "LockedStartLayout" at both the machine and user level
    foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        IF (!(Test-Path -Path $keyPath)) { 
            New-Item -Path $basePath -Name "Explorer"
        }
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 1
        Set-ItemProperty -Path $keyPath -Name "StartLayoutFile" -Value $layoutFile
    }

    #Restart Explorer, open the start menu (necessary to load the new layout), and give it a few seconds to process
    Stop-Process -name explorer
    Start-Sleep -s 5
    $wshell = New-Object -ComObject wscript.shell; $wshell.SendKeys('^{ESCAPE}')
    Start-Sleep -s 5

    #Enable the ability to pin items again by disabling "LockedStartLayout"
    foreach ($regAlias in $regAliases) {
        $basePath = $regAlias + ":\SOFTWARE\Policies\Microsoft\Windows"
        $keyPath = $basePath + "\Explorer" 
        Set-ItemProperty -Path $keyPath -Name "LockedStartLayout" -Value 0
    }

    #Restart Explorer and delete the layout file
    Stop-Process -name explorer

    # Uncomment the next line to make clean start menu default for all new users
    #Import-StartLayout -LayoutPath $layoutFile -MountPath $env:SystemDrive\

    Remove-Item $layoutFile


}

