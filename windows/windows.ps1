Function Add-Path {

    param ( $INCLUDE )

    $OLDPATH = [System.Environment]::GetEnvironmentVariable('PATH', 'machine')
    $NEWPATH = "$OLDPATH;$INCLUDE"
    [Environment]::SetEnvironmentVariable("PATH", "$NEWPATH", "Machine")


}
Function Set-WallPaper($Image) {
  
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
  
    $ret = [Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $Image, $fWinIni)
 
}





workflow Remove-Bloat {
    # dism /Online /Get-ProvisionedAppxPackages | select-string PackageName
    param()


    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.549981C3F5F10_1.1911.21713.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.GetHelp_10.1706.13331.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Getstarted_8.2.22942.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.HEIFImageExtension_1.0.22742.0_x64__8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Microsoft3DViewer_6.1908.2042.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftOfficeHub_18.1903.1152.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftSolitaireCollection_4.4.8204.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftStickyNotes_3.6.73.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MixedReality.Portal_2000.19081.1301.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MSPaint_2019.729.2301.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Office.OneNote_16001.12026.20112.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.People_2019.305.632.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ScreenSketch_2019.904.1644.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.SkypeApp_14.53.77.0_neutral_~_kzf8qxf38zg5c
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.StorePurchaseApp_11811.1001.1813.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VP9VideoExtensions_1.0.22681.0_x64__8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Wallet_2.4.18324.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebMediaExtensions_1.0.20875.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebpImageExtension_1.0.22753.0_x64__8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Windows.Photos_2019.19071.12548.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsAlarms_2019.807.41.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsCamera_2018.826.98.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:microsoft.windowscommunicationsapps_16005.11629.20316.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsFeedbackHub_2019.1111.2029.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsMaps_2019.716.2316.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsSoundRecorder_2019.716.2313.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsStore_11910.1002.513.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Xbox.TCUI_1.23.28002.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxApp_48.49.31001.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGameOverlay_1.46.11001.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGamingOverlay_2.34.28001.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.YourPhone_2019.430.2026.0_neutral_~_8wekyb3d8bbwe
    dism /Online /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneMusic_2019.19071.19011.0_neutral_~_8wekyb3d8bbwe

    Get-AppxPackage -Name *bing* | Remove-AppxPackage
    Get-AppxPackage -Name *xbox* | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.SkypeApp  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.ZuneVideo  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.YourPhone  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.WindowsMaps  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.WindowsFeedbackHub  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.People  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.Office.OneNote  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.MixedReality.Portal  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.MicrosoftSolitaireCollection  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.MicrosoftOfficeHub  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.Microsoft3DViewer  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.HEIFImageExtension  | Remove-AppxPackage
    Get-AppxPackage -Name Microsoft.Getstarted  | Remove-AppxPackage
    Get-AppxPackage -Name *spotify*  | Remove-AppxPackage
    Get-AppxPackage -Name *microsoft.windowscommunicationsapps_*

    # Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://git.io/debloat'))

}

workflow Add-Programs {

    param ()


    Sequential {

        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;


        Parallel {
            # choco install afedteated -y ;
            choco install iobit-uninstaller -y;
            choco install sublimetext3 -y
            choco install vscode -y;
            choco install 7zip.install -y;
            choco install evernote -y;
            choco install intellijidea-ultimate -y;
            choco install docker-desktop -y;
            choco install discord -y
            choco install insomnia-rest-api-client -y;
            choco install krita -y;
            choco install autohotkey -y ;
            choco install git.install -y ;
            choco install spotify -y ;
            choco install obsidian -y ;
        }

        Add-Path "C:\Program Files\Sublime Text 3";
        Add-Path "C:\Program Files\JetBrains\IntelliJ IDEA 2020.2.3\bin";

    }



}


workflow Set-Privacy {


    ##################
    # Privacy Settings
    ##################

    # Privacy: Let apps use my advertising ID: Disable
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo -Name Enabled -Type DWord -Value 0
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost -Name EnableWebContentEvaluation -Type DWord -Value 0


    Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting -Name value -Type DWord -Value 0
    Set-ItemProperty -Path HKLM:\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots -Name value -Type DWord -Value 0

    # Activity Tracking: Disable
    @('EnableActivityFeed', 'PublishUserActivities', 'UploadUserActivities') | ForEach-Object {
        Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\System -Name $_ -Type DWord -Value 0
    }

    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search -Name BingSearchEnabled -Type DWord -Value 0

    # Start Menu: Disale Cortana (Commented out by default - this is personal preference)
    New-Item -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows' -Name 'Windows Search' -ItemType Key
    New-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name AllowCortana -Type DWORD -Value 0

    # Disable Telemetry (requires a reboot to take effect)
    Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection -Name AllowTelemetry -Type DWord -Value 0
    Get-Service DiagTrack, Dmwappushservice | Stop-Service | Set-Service -StartupType Disabled

}

workflow Set-UI {


    # Change Explorer home screen back to "This PC"
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name LaunchTo -Type DWord -Value 1

    # These make "Quick Access" behave much closer to the old "Favorites"
    # Disable Quick Access: Recent Files
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowRecent -Type DWord -Value 0
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer -Name ShowFrequent -Type DWord -Value 0


    # Use the Windows 7-8.1 Style Volume Mixer
    If (-Not (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC")) {
        New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name MTCUVC | Out-Null
    }
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name EnableMtcUvc -Type DWord -Value 0
    # To Restore (Windows 10 Style Volume Control):
    #Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\MTCUVC" -Name EnableMtcUvc -Type DWord -Value 1


    # Dark Theme for Windows
    # Note: the title bar text and such is still black with low contrast, and needs additional tweaks (it'll probably be better in a future build)
    If (-Not (Test-Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize)) {
        New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes -Name Personalize | Out-Null
    }
    Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Type DWord -Value 0
    Set-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize -Name AppsUseLightTheme -Type DWord -Value 0

    # Turn off "Show taskbar on all display"
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name MMTaskbarEnabled -Type DWord -Value 0
    Stop-Process -ProcessName explorer



}
workflow Add-Customizations {

    Set-Privacy

    #TODO Unclutter
    $Wallpaper = (Get-ChildItem -Path $PSScriptRoot -Recurse -Include *.jpg, *.png )[0]
    Set-Wallpaper -Image  $Wallpaper


    InlineScript {

        [microsoft.win32.registry]::SetValue("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run", "Docker Desktop", 0x00000000)
        [microsoft.win32.registry]::SetValue("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search", "SearchboxTaskbarMode", 0x00000000)
        [microsoft.win32.registry]::SetValue("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt", 0x00000000)
        #[microsoft.win32.registry]::SetValue("HKEY_CURRENT_USER\Control Panel\Desktop", "Wallpaper", "C:\Users\$env:UserName\OneDrive\customizations\Windows\Wallpaper.jpg")

    }


}







workflow Set-Environment {
    param ( )

    Remove-Bloat
    Add-Programs
    Add-Customizations

    Restart-Computer;
}


Set-Environment


#Todo https://docs.microsoft.com/en-us/windows/win32/controls/themesfileformat-overview#creating-a-theme-file

