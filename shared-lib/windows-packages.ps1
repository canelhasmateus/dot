$RegistryModule = Join-Path $PSScriptRoot "registry.ps1"
. $RegistryModule

function Join-AsRegex( $strings , $sep) {
    $regex = ""
    foreach ($element in $strings) {
        $regex = $regex + $sep + $element
    }
    
    $regex = "(?i)" + $regex.Substring( 1 )
    
    $WhitelistedApps = [Regex]::new($regex)
    
    return $WhitelistedApps
}

function Optimize-AppxPackages {

    $Temp = Join-Path $PSScriptRoot "./VCLLibs.appx"
    Invoke-RestMethod -URI "https://aka.ms/Microsoft.VCLibs.x86.14.00.Desktop.appx" -OutFile $Temp
    Add-AppxPackage $Temp
    Remove-Item $Temp -Force
    
    #
    #
    
    Write-Information "Removing Bloatware Packages"
    $ContentDeliveryManager = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    $StartMenu = @(
        "ContentDeliveryAllowed"
        "FeatureManagementEnabled"
        "OemPreInstalledAppsEnabled"
        "PreInstalledAppsEnabled"
        "PreInstalledAppsEverEnabled"
        "SilentInstalledAppsEnabled"
        "SubscribedContent-314559Enabled"
        "SubscribedContent-338387Enabled"
        "SubscribedContent-338388Enabled"
        "SubscribedContent-338389Enabled"
        "SubscribedContent-338393Enabled"
        "SubscribedContentEnabled"
        "SystemPaneSuggestionsEnabled" 
    )  | ForEach-Object {
        return @{
            Path  = "$ContentDeliveryManager"
            Key   = "$_"
            Value = 0
            Kind  = "dword"
        }

    } 
    
    $CloudContent = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent"        
    $WindowsStore = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\WindowsStore"
    $Holo = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Holographic"    
    $Features = @(
        @{
            Path  = "$CloudContent"
            Key   = "DisableWindowsConsumerFeatures"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$WindowsStore"
            Key   = "AutoDownload"
            Value = 2
            kind  = "dword"
        }

        @{
            Path  = "$Holo"
            Key   = "FirstRunSucceeded"
            Value = 0
            kind  = "dword"
        }

    ) 
    
    Add-Registry @( 
        $StartMenu 
        $Features)

    
    $allowList = @(
        ".*callingshellapp.*"
        ".*shellexperiencehost.*"
        ".*startmenuexperiencehost.*"
        ".*windowsstore.*"
        ".*immersivecontrolpanel.*"
        ".*xaml.*"
        ".*mspaint.*"
        ".*windows.photos.*"
        ".*calculator.*"
        ".*windowsstore.*"
        ".*microsoftedge.*"
        ".*mspaint.*"
        ".*ncsiuwpapp.*"
        ".*windows.cbspreview.*"
        ".*client.cbs.*"
        ".*win32webviewhost.*"
        ".*vclibs.*"
        ".*devkit.*"
        ".*capturepicker.*"
        ".*lockapp.*"
    )
    # Todo Better Function for this.
    $WhitelistedApps = Join-AsRegex $allowList "|"
    Get-AppxPackage -AllUsers | Where-Object { $_.Name -NotMatch $WhitelistedApps } | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxPackage | Where-Object { $_.Name -NotMatch $WhitelistedApps } | Remove-AppxPackage -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -NotMatch $WhitelistedApps } | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue

}
