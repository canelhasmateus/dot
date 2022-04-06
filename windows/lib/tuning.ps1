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
function Elevate-Privileges {
    param($Privilege)
    $Definition = @"
    using System;
    using System.Runtime.InteropServices;
    public class AdjPriv {
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
        [DllImport("advapi32.dll", SetLastError = true)]
            internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);
        [StructLayout(LayoutKind.Sequential, Pack = 1)]
            internal struct TokPriv1Luid {
                public int Count;
                public long Luid;
                public int Attr;
            }
        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
        public static bool EnablePrivilege(long processHandle, string privilege) {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr(processHandle);
            IntPtr htok = IntPtr.Zero;
            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;
            retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
            return retVal;
        }
    }
"@
    $ProcessHandle = (Get-Process -id $pid).Handle
    $type = Add-Type $definition -PassThru
    $type[0]::EnablePrivilege($processHandle, $Privilege)
}

function Optimize-WindowsDefender {

    Elevate-Privileges
    Write-Information "Disabling Windows Defender via Group Policies"

    
    $SpyNet = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender\Spynet"
    $Services = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services'    
    $DefenderPolicies = 'HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows Defender'
    $Changes = @(

        @{
            Path  = "$DefenderPolicies"
            Key   = "DisableAntiSpyware"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$DefenderPolicies"
            Key   = "DisableRoutinelyTakingAction"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$DefenderPolicies"
            Key   = "DisableRealtimeMonitoring"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$SpyNet"
            Key   = "SpyNetReporting"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$SpyNet"
            Key   = "SubmitSamplesConsent"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$Services\WinDefend"
            Key   = "AutorunsDisabled"
            Value = 3
            kind  = "dword"
        }
        @{
            Path  = "$Services\WinDefend"
            Key   = "Start"
            Value = 4
            kind  = "dword"
        }
        
        @{
            Path  = "$Services\WdNisSvc"
            Key   = "AutorunsDisabled"
            Value = 3
            kind  = "dword"
        }
        @{
            Path  = "$Services\WdNisSvc"
            Key   = "Start"
            Value = 4
            kind  = "dword"
        }
        @{
            Path  = "$Services\Sense"
            Key   = "AutorunsDisabled"
            Value = 3
            kind  = "dword"
        }
        @{
            Path  = "$Services\Sense"
            Key   = "Start"
            Value = 4
            kind  = "dword"
        }
        

    )

    Add-Registry $Changes

    


    67..90 | foreach-object {
        $drive = [char]$_
        Add-MpPreference -ExclusionPath "$($drive):\" -ErrorAction SilentlyContinue
        Add-MpPreference -ExclusionProcess "$($drive):\*" -ErrorAction SilentlyContinue
    }


    Set-MpPreference -DisableArchiveScanning 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableBehaviorMonitoring 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableIntrusionPreventionSystem 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableIOAVProtection 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableRemovableDriveScanning 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableBlockAtFirstSeen 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableScanningNetworkFiles 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableScriptScanning 1 -ErrorAction SilentlyContinue
    Set-MpPreference -DisableRealtimeMonitoring 1 -ErrorAction SilentlyContinue


    Set-MpPreference -LowThreatDefaultAction Allow -ErrorAction SilentlyContinue
    Set-MpPreference -ModerateThreatDefaultAction Allow -ErrorAction SilentlyContinue
    Set-MpPreference -HighThreatDefaultAction Allow -ErrorAction SilentlyContinue


    ## STEP 2 : Disable services, we cannot stop them, but we can disable them (they won't start next reboot)
    $svc_list = @("WdNisSvc", "WinDefend", "Sense")
    foreach ($svc in $svc_list) {
        if ($(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc")) {
            if ( $(Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc").Start -eq 4) {
                Write-Host "        [i] Service $svc already disabled"
            }
            else {
                Write-Host "        [i] Disable service $svc (next reboot)"
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$svc" -Name Start -Value 4
            }
        }
        else {
            Write-Host "        [i] Service $svc already deleted"
        }
    }

    # WdnisDrv : Network Inspection System Driver
    # wdfilter : Mini-Filter Driver
    # wdboot : Boot Driver
    $drv_list = @("WdnisDrv", "wdfilter", "wdboot")
    foreach ($drv in $drv_list) {
        if ($(Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv")) {
            if ( $(Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv").Start -eq 4) {
                Write-Host "        [i] Driver $drv already disabled"
            }
            else {
                Write-Host "        [i] Disable driver $drv (next reboot)"
                Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\$drv" -Name Start -Value 4
            }
        }
        else {
            Write-Host "        [i] Driver $drv already deleted"
        }
    }

    # Delete files
    Delete-Show-Error "C:\ProgramData\Windows\Windows Defender\"
    Delete-Show-Error "C:\ProgramData\Windows\Windows Defender Advanced Threat Protection\"

    # Delete drivers
    Delete-Show-Error "C:\Windows\System32\drivers\wd\"

    # Delete service registry entries
    foreach ($svc in $svc_list) {
        Delete-Show-Error "HKLM:\SYSTEM\CurrentControlSet\Services\$svc"
    }

    # Delete drivers registry entries
    foreach ($drv in $drv_list) {
        Delete-Show-Error "HKLM:\SYSTEM\CurrentControlSet\Services\$drv"
    }

    # Cloud-delivered protection:
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name SpyNetReporting -Value 0
    # Automatic Sample submission
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Real-Time Protection" -Name SubmitSamplesConsent -Value 0
    # Tamper protection
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender\Features" -Name TamperProtection -Value 4
            
    # Disable in registry
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name DisableAntiSpyware -Value 1


    # todo
    Write-Information "Removing Windows Defender context menu item"
    Set-Item "HKLM:\SOFTWARE\Classes\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32" ""
    
    Write-Information "Removing Windows Defender GUI / tray from autorun"
    Remove-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "WindowsDefender" -ea 0

}

function Flatten ( $Array ) {
        
    return $Array | ForEach-Object {
        $_
    }

}
function Disable-Services( $List) {
    $Flattened = Flatten $List
    $Flattened | ForEach-Object {
         
        $ServiceName = $_
        
        $Service = Get-Service -Name $serviceName 
        $PreviousStatus = $Service.StartType
    
        $Service | Set-Service -StartupType Disabled -PassThru | Stop-Service -ErrorAction SilentlyContinue
        $Service = Get-Service -Name $serviceName  
        
        Start-Sleep -Milliseconds 200

        $CurrentStatus = $Service.StartType
        

        return [PSCustomObject]@{
            Success        = $CurrentStatus -eq "Disabled"
            Service        = $ServiceName
            PreviousStatus = $PreviousStatus
            CurrentStatus  = $CurrentStatus
        }         

    } | Format-Table -AutoSize 

}
function Enable-Services( $List) {
    $Flattened = Flatten $List
    $Flattened | ForEach-Object {
         
        $ServiceName = $_
        
        $Service = Get-Service -Name $serviceName 
        $PreviousStatus = $Service.StartType
    
        $Service | Set-Service -StartupType Automatic -PassThru | Start-Service -ErrorAction SilentlyContinue
        $Service = Get-Service -Name $serviceName  
        
        Start-Sleep -Milliseconds 200

        $CurrentStatus = $Service.StartType
        

        return [PSCustomObject]@{
            Success        = $CurrentStatus -eq "Automatic"
            Service        = $ServiceName
            PreviousStatus = $PreviousStatus
            CurrentStatus  = $CurrentStatus
        }         

    } | Format-Table -AutoSize 

}
function Optimize-Services {

    $NoPermission = @(
        "CDPUserSvc_57b89"
        "AppXSvc" # AppX Deployment Service (AppXSVC)
        "DoSvc" # Delivery Optimization
        "SecurityHealthService" # Windows Security Service
        "WdNisSvc" # Microsoft Defender Antivirus Network Inspection Service
        "WinDefend" # Microsoft Defender Antivirus Service
        "WinHttpAutoProxySvc" # WinHTTP Web Proxy Auto-Discovery Service
        "wscsvc" # Security Center
        "mpssvc" # Windows Defender Firewall
        "RpcEptMapper" # RPC Endpoint Mapper
        "RpcSs" # Remote Procedure Call (RPC)
        "SgrmBroker" # System Guard Runtime Monitor Broker
        "StateRepository" # State Repository Service
        "SystemEventsBroker" # System Events Broker
        "TimeBrokerSvc" # Time Broker
        "CoreMessagingRegistrar" #  CoreMessaging
        "DcomLaunch" #  DCOM Server Process Launcher
        "Dnscache" #  DNS Client
        "LSM" #  Local Session Manager
        "LxssManager" #  LxssManager
    )

    $Manual = @( 
        
        "FontCache3.0.0.0" # Windows Presentation Foundation Font Cache 3.0.0.0
        "SstpSvc" # Secure Socket Tunneling Protocol Service
        "DeviceAssociationService" #  Device Association Service
        "hidserv" #  Human Interface Device Service
        "DisplayEnhancementService" #  Display Enhancement Service
        "hns" #  Host Network Service
        "HvHost" #  HV Host Service
        "KeyIso" #  CNG Key Isolation
        "netprofm" #  Network List Service
        "nvagent" #  Network Virtualization Service
        "SharedAccess" #  Internet Connection Sharing (ICS)
        
    )
    $Using = @( 
        "Audiosrv" #  Windows Audio
        "Winmgmt" # Windows Management Instrumentation ; Required by Restart-Computer and probably others
        "Wcmsvc" # Windows Connection Manager ; Required for internet        
        "LanmanServer" # Server ; Required by docker
        "LanmanWorkstation" # Workstation ; Required by docker
        "com.docker.service" #  Docker Desktop Service
    )
    $Investigate = @(
        "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
        "Appinfo" #  Application Information
        "AudioEndpointBuilder" #  Windows Audio Endpoint Builder
        "camsvc" # Capability Access Manager Service
        "CDPSvc" # Connected Devices Platform Service
        "cplspcon" # Intel(R) Content Protection HDCP Service
        "DispBrokerDesktopSvc" #  Display Policy Service
        "EventLog" #  Windows Event Log
        "igccservice" # Intel(R) Graphics Command Center Service
        "igfxCUIService2.0.0.0" # Intel(R) HD Graphics Control Panel Service
        "InstallService" # Microsoft Store Install Service
        "jhi_service" # Intel(R) Dynamic Application Loader Host Interface Service
        "lmhosts" # TCP/IP NetBIOS Helper
        "NcbService" # Network Connection Broker
        "NlaSvc" #  Network Location Awareness
        "nsi" #  Network Store Interface Service
        "ProfSvc" # User Profile Service
        "RasMan" # Remote Access Connection Manager
        "SamSs" #  Security Accounts Manager
        "ShellHWDetection" # Shell Hardware Detection
        "StorSvc" #  Storage Service
        "TokenBroker" # Web Account Manager
        "UserManager" # User Manager
        "VaultSvc" # Credentials Manager
        "WlanSvc" #  WLAN AutoConfig
        "wlidsvc" # Microsoft Account Sign-in Assistant
        "WSearch" # Windows Search
    )

    $Stoppable = @(    
        "BTAGService" #Bluetooth
        "BthAvctpSvc" #Bluetooth
        "bthserv" #Bluetooth
        "diagnosticshub.standardcollector.service" # Microsoft (R) Diagnostics Hub Standard Collector Service
        "DiagTrack"                                # Diagnostics Tracking Service
        "DPS" # Diagnostic Policy Service
        "DsSvc"
        "DusmSvc" # Data Usage
        "fdPHost" # Function Discovery Provider Host
        "FDResPub" # Function Discovery Resource Publication
        "lfsvc"                                    # Geolocation Service
        "MapsBroker"                               # Downloaded Maps Manager
        "NcdAutoSetup" # Network Connected Devices Auto-Setup
        
        "PcaSvc" # Program Compatibility Assistant Service
        "PlugPlay" # Plug and Play
        "RemoteRegistry"                           # Remote Registry
        "RmSvc" # Radio Management Service
        "SENS" # System Event Notification Service
        "Spooler" # Print Spooler
        "SSDPSRV" # SSDP Discovery
        "SysMain" # SysMain
        "TabletInputService" # Touch Keyboard and Handwriting Panel Service
        "TbtP2pShortcutService" # Thunderbolt(TM) Peer to Peer Shortcut
        "TrkWks" # Distributed Link Tracking Client
        "UsoSvc" # Update Orchestrator Service
        "WbioSrvc" # Windows Biometric Service (required for Fingerprint reader / facial detection)
        "WdiServiceHost" # Diagnostic Service Host
        "WdiSystemHost" # Diagnostic System Host
        "WMPNetworkSvc" # Windows Media Player Network Sharing Service
        "WpnService" # Windows Push Notifications System Service
        "wuauserv" # Windows Update
        "XblAuthManager"                           # Xbox Live Auth Manager
        "XblGameSave"                              # Xbox Live Game Save Service
        "XboxNetApiSvc"                            # Xbox Live Networking Service 
    )
    

    Disable-Services @(         
        $Stoppable
    )

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


function Optimize-Privacy {

    
    Write-Information "Microsoft Edge settings"
    $MicrosoftEdge = "HKEY_CURRENT_USER\SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge"
    $EdgeChanges = @(
        @{
            Path  = "$MicrosoftEdge\Main"
            Key   = "DoNotTrack"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$MicrosoftEdge\User\Default\SearchScopes"
            Key   = "ShowSearchSuggestionsGlobal"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$MicrosoftEdge\FlipAhead"
            Key   = "FPEnabled"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$MicrosoftEdge\PhishingFilter"
            Key   = "EnabledV9"
            Value = 0
            kind  = "dword"
        }

    ) 
        
    Add-Registry $EdgeChanges

    $Microsoft = "HKEY_CURRENT_USER\SOFTWARE\Microsoft"
    $SensorPermissions = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions"
    $SensorState = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
    $LocationConfig = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
    $CurrentUser = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion"
    $Printers = "HKEY_CURRENT_USER\Printers\Defaults"
    $WInput = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input"
    $IntUserProfile = "HKEY_CURRENT_USER\Control Panel\International\User Profile"
    $Policies = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows"    
    $PrivacyChanges = @(

        @{
            Path  = "$Microsoft\Personalization"
            Key   = "AcceptedPrivacyPolicy"
            Value = 0
            kind  = "dword"
        }

        @{
            Path  = "$Microsoft\InputPersonalization"
            Key   = "RestrictImplicitTextCollection"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$Microsoft\InputPersonalization"
            Key   = "RestrictImplicitInkCollection"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$Microsoft\InputPersonalization\TrainedDataStore"
            Key   = "HarvestContacts"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$SensorPermissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
            Key   = "SensorPermissionState"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$SensorState"
            Key   = "SensorPermissionState"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$LocationConfig"
            Key   = "Status"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$IntUserProfile"
            Key   = "HttpAcceptLanguageOptOut"
            Value = 1
            kind  = "dword"
        }
        @{
            Path  = "$Printers"
            Key   = "NetID"
            Value = "{00000000-0000-0000-0000-000000000000}"
            kind  = "string"
        }

        @{
            Path  = "$WInput\TIPC"
            Key   = "Enabled"
            Value = 0
            kind  = "dword"
        }
        
        @{
            Path  = "$CurrentUser\AdvertisingInfo"
            Key   = "Enabled"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$Policies\System"
            Key   = "PublishUserActivities"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$Policies\System"
            Key   = "UploadUserActivities"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "$Policies\DataCollection"
            Key   = "UploadUserActivities"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
            Key   = "UploadUserActivities"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
            Key   = "UploadUserActivities"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
            Key   = "Enabled"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = "HKEY_CURRENT_USER\Software\Microsoft\Siuf\Rules"
            Key   = "PeriodInNanoSeconds"
            Value = 0
            kind  = "dword"
        }
        

    
    )

    Add-Registry $PrivacyChanges    

    
    
}

function Optimize-NetworkTraffic {
    
    Write-Information "Optimizing Network"

    # todo

    $DeviceAccess = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global"
    $DeviceChanges = Get-ChildItem "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global" | ForEach-Object {
        $key = $_.PSChildName        
        $Path = "$DeviceAccess\$key"        
        return @( 
            @{
                Path  = $Path
                Key   = "Type"
                Value = "InterfaceClass"
                kind  = "string"
            }
            @{
                Path  = $Path
                Key   = "Value"
                Value = "Deny"
                kind  = "string"
            }
            @{
                Path  = $Path
                Key   = "InitialAppValue"
                Value = "Unspecified"
                kind  = "string"
            }

        )
    } 
    Add-Registry $DeviceChanges
    
    
    
    Remove-NetFirewallRule -DisplayName "Block SSDP" -ErrorAction SilentlyContinue
    New-NetFirewallRule -DisplayName "Block SSDP" -Direction Outbound -RemotePort 1900 -Protocol UDP -Action Block
    
    #Disables Wi-fi Sense
    $Wifi = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\Wifi"
    $WifiChanges = @( 
        @{
            Path  = $WiFi
            Key   = "AllowWiFiHotSpotReporting"
            Value = 0
            kind  = "dword"
        }
        @{
            Path  = $WiFi
            Key   = "AllowAutoConnectToWiFiSenseHotspots"
            Value = 0
            kind  = "dword"
        }

    )
    Add-Registry $WifiChanges
    
    
    Write-Information "Adding telemetry domains to hosts file"
    $hosts_file = "$env:systemroot\System32\drivers\etc\hosts"
    $domains = @(
        "184-86-53-99.deploy.static.akamaitechnologies.com"
        "a-0001.a-msedge.net"
        "a-0002.a-msedge.net"
        "a-0003.a-msedge.net"
        "a-0004.a-msedge.net"
        "a-0005.a-msedge.net"
        "a-0006.a-msedge.net"
        "a-0007.a-msedge.net"
        "a-0008.a-msedge.net"
        "a-0009.a-msedge.net"
        "a1621.g.akamai.net"
        "a1856.g2.akamai.net"
        "a1961.g.akamai.net"
        #"a248.e.akamai.net"            # makes iTunes download button disappear (#43)
        "a978.i6g1.akamai.net"
        "a.ads1.msn.com"
        "a.ads2.msads.net"
        "a.ads2.msn.com"
        "ac3.msn.com"
        "ad.doubleclick.net"
        "adnexus.net"
        "adnxs.com"
        "ads1.msads.net"
        "ads1.msn.com"
        "ads.msn.com"
        "aidps.atdmt.com"
        "aka-cdn-ns.adtech.de"
        "a-msedge.net"
        "any.edge.bing.com"
        "a.rad.msn.com"
        "az361816.vo.msecnd.net"
        "az512334.vo.msecnd.net"
        "b.ads1.msn.com"
        "b.ads2.msads.net"
        "bingads.microsoft.com"
        "b.rad.msn.com"
        "bs.serving-sys.com"
        "c.atdmt.com"
        "cdn.atdmt.com"
        "cds26.ams9.msecn.net"
        "choice.microsoft.com"
        "choice.microsoft.com.nsatc.net"
        "compatexchange.cloudapp.net"
        "corpext.msitadfs.glbdns2.microsoft.com"
        "corp.sts.microsoft.com"
        "cs1.wpc.v0cdn.net"
        "db3aqu.atdmt.com"
        "df.telemetry.microsoft.com"
        "diagnostics.support.microsoft.com"
        "e2835.dspb.akamaiedge.net"
        "e7341.g.akamaiedge.net"
        "e7502.ce.akamaiedge.net"
        "e8218.ce.akamaiedge.net"
        "ec.atdmt.com"
        "fe2.update.microsoft.com.akadns.net"
        "feedback.microsoft-hohm.com"
        "feedback.search.microsoft.com"
        "feedback.windows.com"
        "flex.msn.com"
        "g.msn.com"
        "h1.msn.com"
        "h2.msn.com"
        "hostedocsp.globalsign.com"
        "i1.services.social.microsoft.com"
        "i1.services.social.microsoft.com.nsatc.net"
        #"ipv6.msftncsi.com"                    # Issues may arise where Windows 10 thinks it doesn't have internet
        #"ipv6.msftncsi.com.edgesuite.net"      # Issues may arise where Windows 10 thinks it doesn't have internet
        "lb1.www.ms.akadns.net"
        "live.rads.msn.com"
        "m.adnxs.com"
        "msedge.net"
        #"msftncsi.com"
        "msnbot-65-55-108-23.search.msn.com"
        "msntest.serving-sys.com"
        "oca.telemetry.microsoft.com"
        "oca.telemetry.microsoft.com.nsatc.net"
        "onesettings-db5.metron.live.nsatc.net"
        "pre.footprintpredict.com"
        "preview.msn.com"
        "rad.live.com"
        "rad.msn.com"
        "redir.metaservices.microsoft.com"
        "reports.wes.df.telemetry.microsoft.com"
        "schemas.microsoft.akadns.net"
        "secure.adnxs.com"
        "secure.flashtalking.com"
        "services.wes.df.telemetry.microsoft.com"
        "settings-sandbox.data.microsoft.com"
        #"settings-win.data.microsoft.com"       # may cause issues with Windows Updates
        "sls.update.microsoft.com.akadns.net"
        #"sls.update.microsoft.com.nsatc.net"    # may cause issues with Windows Updates
        "sqm.df.telemetry.microsoft.com"
        "sqm.telemetry.microsoft.com"
        "sqm.telemetry.microsoft.com.nsatc.net"
        "ssw.live.com"
        "static.2mdn.net"
        "statsfe1.ws.microsoft.com"
        "statsfe2.update.microsoft.com.akadns.net"
        "statsfe2.ws.microsoft.com"
        "survey.watson.microsoft.com"
        "telecommand.telemetry.microsoft.com"
        "telecommand.telemetry.microsoft.com.nsatc.net"
        "telemetry.appex.bing.net"
        "telemetry.microsoft.com"
        "telemetry.urs.microsoft.com"
        "vortex-bn2.metron.live.com.nsatc.net"
        "vortex-cy2.metron.live.com.nsatc.net"
        "vortex.data.microsoft.com"
        "vortex-sandbox.data.microsoft.com"
        "vortex-win.data.microsoft.com"
        "cy2.vortex.data.microsoft.com.akadns.net"
        "watson.live.com"
        "watson.microsoft.com"
        "watson.ppe.telemetry.microsoft.com"
        "watson.telemetry.microsoft.com"
        "watson.telemetry.microsoft.com.nsatc.net"
        "wes.df.telemetry.microsoft.com"
        "win10.ipv6.microsoft.com"
        "www.bingads.microsoft.com"
        "www.go.microsoft.akadns.net"
        #"www.msftncsi.com"                         # Issues may arise where Windows 10 thinks it doesn't have internet
        "client.wns.windows.com"
        #"wdcp.microsoft.com"                       # may cause issues with Windows Defender Cloud-based protection
        #"dns.msftncsi.com"                         # This causes Windows to think it doesn't have internet
        #"storeedgefd.dsx.mp.microsoft.com"         # breaks Windows Store
        "wdcpalt.microsoft.com"
        "settings-ssl.xboxlive.com"
        "settings-ssl.xboxlive.com-c.edgekey.net"
        "settings-ssl.xboxlive.com-c.edgekey.net.globalredir.akadns.net"
        "e87.dspb.akamaidege.net"
        "insiderservice.microsoft.com"
        "insiderservice.trafficmanager.net"
        "e3843.g.akamaiedge.net"
        "flightingserviceweurope.cloudapp.net"
        #"sls.update.microsoft.com"                 # may cause issues with Windows Updates
        "static.ads-twitter.com"                    # may cause issues with Twitter login
        "www-google-analytics.l.google.com"
        "p.static.ads-twitter.com"                  # may cause issues with Twitter login
        "hubspot.net.edge.net"
        "e9483.a.akamaiedge.net"

        #"www.google-analytics.com"
        #"padgead2.googlesyndication.com"
        #"mirror1.malwaredomains.com"
        #"mirror.cedia.org.ec"
        "stats.g.doubleclick.net"
        "stats.l.doubleclick.net"
        "adservice.google.de"
        "adservice.google.com"
        "googleads.g.doubleclick.net"
        "pagead46.l.doubleclick.net"
        "hubspot.net.edgekey.net"
        "insiderppe.cloudapp.net"                   # Feedback-Hub
        "livetileedge.dsx.mp.microsoft.com"

        # extra
        "fe2.update.microsoft.com.akadns.net"
        "s0.2mdn.net"
        "statsfe2.update.microsoft.com.akadns.net"
        "survey.watson.microsoft.com"
        "view.atdmt.com"
        "watson.microsoft.com"
        "watson.ppe.telemetry.microsoft.com"
        "watson.telemetry.microsoft.com"
        "watson.telemetry.microsoft.com.nsatc.net"
        "wes.df.telemetry.microsoft.com"
        "m.hotmail.com"

        # can cause issues with Skype (#79) or other services (#171)
        "apps.skype.com"
        "c.msn.com"
        # "login.live.com"                  # prevents login to outlook and other live apps
        "pricelist.skype.com"
        "s.gateway.messenger.live.com"
        "ui.skype.com"
    )
    Write-Information "" | Out-File -Encoding ASCII -Append $hosts_file
    foreach ($domain in $domains) {
        if (-Not (Select-String -Path $hosts_file -Pattern $domain)) {
            Write-Information "0.0.0.0 $domain" | Out-File -Encoding ASCII -Append $hosts_file
        }
    }

    Write-Information "Adding telemetry ips to firewall"
    $ips = @(
        # Windows telemetry
        "134.170.30.202"
        "137.116.81.24"
        "157.56.106.189"
        "184.86.53.99"
        "2.22.61.43"
        "2.22.61.66"
        "204.79.197.200"
        "23.218.212.69"
        "64.4.54.254"
        "65.39.117.230"
        "65.52.108.33"   # Causes problems with Microsoft Store
        "65.55.108.23"

        # NVIDIA telemetry
        "8.36.80.197"
        "8.36.80.224"
        "8.36.80.252"
        "8.36.113.118"
        "8.36.113.141"
        "8.36.80.230"
        "8.36.80.231"
        "8.36.113.126"
        "8.36.80.195"
        "8.36.80.217"
        "8.36.80.237"
        "8.36.80.246"
        "8.36.113.116"
        "8.36.113.139"
        "8.36.80.244"
        "216.228.121.209"
    )
    Remove-NetFirewallRule -DisplayName "Block Telemetry IPs" -ErrorAction SilentlyContinue
    New-NetFirewallRule -DisplayName "Block Telemetry IPs" -Direction Outbound `
        -Action Block -RemoteAddress ([string[]]$ips)
}

function Optimize-Others {
    Write-Information @"
###############################################################################
#       _______  _______  ______     __   __  _______  ______   _______       #
#      |       ||       ||      |   |  |_|  ||       ||      | |       |      #
#      |    ___||   _   ||  _    |  |       ||   _   ||  _    ||    ___|      #
#      |   | __ |  | |  || | |   |  |       ||  | |  || | |   ||   |___       #
#      |   ||  ||  |_|  || |_|   |  |       ||  |_|  || |_|   ||    ___|      #
#      |   |_| ||       ||       |  | ||_|| ||       ||       ||   |___       #
#      |_______||_______||______|   |_|   |_||_______||______| |_______|      #
#                                                                             #
#      God Mode has been enabled, check out the new link on your Desktop      #
#                                                                             #
###############################################################################
"@
    $DesktopPath = [Environment]::GetFolderPath("Desktop");
    mkdir "$DesktopPath\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}"


    # SSD life improvement
    # fsutil behavior set DisableLastAccess 1
    # fsutil behavior set EncryptPagingFile 0

    

    #Disable-MMAgent -ApplicationLaunchPrefetching
    #  Can do it selectively to program, like this:
    # reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v AllowPrelaunch /t REG_DWORD /d "0" /f

    # Disable prefetch. Need to do via registry because unauthorized otherwise. 
    #Disable-MMAgent -ApplicationPreLaunch -ErrorAction Ignore
    #reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v EnablePrefetcher /t REG_DWORD /d "0" /f
    
    

    Enable-MMAgent -PageCombining
    #Disable-MMAgent -MemoryCompression
    
    
    
    #Get-MMAgent

    # echo "Now you can also disable service SysMain (former Superfetch) in case it's not used."
    #Get-Service "SysMain" | Set-Service -StartupType Disabled -PassThru | Stop-Service
    #Write-Information "Disable background access of default apps"
    #foreach ($key in (Get-ChildItem "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications")) {
    #    Set-ItemProperty -Path ("HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\" + $key.PSChildName) "Disabled" 1
    #}

}


function Todo {


    $NetworkManager = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager"
    $GlobalDevice = "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled"
    # The following section can cause problems with network / internet connectivity
    # in generel. See the corresponding issue:
    # https://github.com/W4RH4WK/Debloat-Windows-10/issues/270
    #Write-Information "Do not share wifi networks"
        
    # [microsoft.win32.registry]::SetValue(
    #     "$NetworkManager\features", 
    #     "WiFiSenseCredShared", 0)

    # [microsoft.win32.registry]::SetValue(
    #     "$NetworkManager\features", 
    #     "WiFiSenseOpen", 0)

    # [microsoft.win32.registry]::SetValue(
    #     "$NetworkManager\config", 
    #     "AutoConnectAllowedOEM", 0x00000000)

    # $user = New-Object System.Security.Principal.NTAccount($env:UserName)
    # $sid = $user.Translate([System.Security.Principal.SecurityIdentifier]).value
    # [microsoft.win32.registry]::SetValue(
    #     "$NetworkManager\features\$sid", 
    #     "FeatureStates", 0x33c)

    
    # Write-Information "Disable synchronisation of settings"
    # These only apply if you log on using Microsoft account
    # Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "BackupPolicy" 0x3c
    # Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "DeviceMetadataUploaded" 0
    # Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync" "PriorLogons" 1
    # $groups = @(
    #     "Accessibility"
    #     "AppSync"
    #     "BrowserSettings"
    #     "Credentials"
    #     "DesktopTheme"
    #     "Language"
    #     "PackageState"
    #     "Personalization"
    #     "StartLayout"
    #     "Windows"
    # )
    # foreach ($group in $groups) {
    #     New-FolderForced -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group"
    #     Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\$group" "Enabled" 0
    # }

    # 

    function Optimize-BackgroundTasks {

        $tasks = @(
            "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
            "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
            "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
            "\Microsoft\Windows\Windows Defender\Windows Defender Verification"
        )

        foreach ($task in $tasks) {
            $parts = $task.split('\')
            $name = $parts[-1]
            $path = $parts[0..($parts.length - 2)] -join '\'

            Write-Information "Trying to disable scheduled task $name"
            Disable-ScheduledTask -TaskName "$name" -TaskPath "$path"
        }


        $tasks = @(
            # Windows base scheduled tasks
            "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319"
            "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64"
            "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 64 Critical"
            "\Microsoft\Windows\.NET Framework\.NET Framework NGEN v4.0.30319 Critical"

            #"\Microsoft\Windows\Active Directory Rights Management Services Client\AD RMS Rights Policy Template Management (Automated)"
            #"\Microsoft\Windows\Active Directory Rights Management Services Client\AD RMS Rights Policy Template Management (Manual)"

            #"\Microsoft\Windows\AppID\EDP Policy Manager"
            #"\Microsoft\Windows\AppID\PolicyConverter"
            "\Microsoft\Windows\AppID\SmartScreenSpecific"
            #"\Microsoft\Windows\AppID\VerifiedPublisherCertStoreCheck"

            "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
            "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
            #"\Microsoft\Windows\Application Experience\StartupAppTask"

            #"\Microsoft\Windows\ApplicationData\CleanupTemporaryState"
            #"\Microsoft\Windows\ApplicationData\DsSvcCleanup"

            #"\Microsoft\Windows\AppxDeploymentClient\Pre-staged app cleanup"

            "\Microsoft\Windows\Autochk\Proxy"

            #"\Microsoft\Windows\Bluetooth\UninstallDeviceTask"

            #"\Microsoft\Windows\CertificateServicesClient\AikCertEnrollTask"
            #"\Microsoft\Windows\CertificateServicesClient\KeyPreGenTask"
            #"\Microsoft\Windows\CertificateServicesClient\SystemTask"
            #"\Microsoft\Windows\CertificateServicesClient\UserTask"
            #"\Microsoft\Windows\CertificateServicesClient\UserTask-Roam"

            #"\Microsoft\Windows\Chkdsk\ProactiveScan"

            #"\Microsoft\Windows\Clip\License Validation"

            "\Microsoft\Windows\CloudExperienceHost\CreateObjectTask"

            "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
            "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
            "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"

            #"\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan"
            #"\Microsoft\Windows\Data Integrity Scan\Data Integrity Scan for Crash Recovery"

            #"\Microsoft\Windows\Defrag\ScheduledDefrag"

            #"\Microsoft\Windows\Diagnosis\Scheduled"

            #"\Microsoft\Windows\DiskCleanup\SilentCleanup"

            "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
            #"\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticResolver"

            #"\Microsoft\Windows\DiskFootprint\Diagnostics"

            "\Microsoft\Windows\Feedback\Siuf\DmClient"

            #"\Microsoft\Windows\File Classification Infrastructure\Property Definition Sync"

            #"\Microsoft\Windows\FileHistory\File History (maintenance mode)"

            #"\Microsoft\Windows\LanguageComponentsInstaller\Installation"
            #"\Microsoft\Windows\LanguageComponentsInstaller\Uninstallation"

            #"\Microsoft\Windows\Location\Notifications"
            #"\Microsoft\Windows\Location\WindowsActionDialog"

            #"\Microsoft\Windows\Maintenance\WinSAT"

            #"\Microsoft\Windows\Maps\MapsToastTask"
            #"\Microsoft\Windows\Maps\MapsUpdateTask"

            #"\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
            #"\Microsoft\Windows\MemoryDiagnostic\RunFullMemoryDiagnostic"

            "\Microsoft\Windows\Mobile Broadband Accounts\MNO Metadata Parser"

            #"\Microsoft\Windows\MUI\LPRemove"

            #"\Microsoft\Windows\Multimedia\SystemSoundsService"

            #"\Microsoft\Windows\NetCfg\BindingWorkItemQueueHandler"

            #"\Microsoft\Windows\NetTrace\GatherNetworkInfo"

            #"\Microsoft\Windows\Offline Files\Background Synchronization"
            #"\Microsoft\Windows\Offline Files\Logon Synchronization"

            #"\Microsoft\Windows\PI\Secure-Boot-Update"
            #"\Microsoft\Windows\PI\Sqm-Tasks"

            #"\Microsoft\Windows\Plug and Play\Device Install Group Policy"
            #"\Microsoft\Windows\Plug and Play\Device Install Reboot Required"
            #"\Microsoft\Windows\Plug and Play\Plug and Play Cleanup"
            #"\Microsoft\Windows\Plug and Play\Sysprep Generalize Drivers"

            #"\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"

            #"\Microsoft\Windows\Ras\MobilityManager"

            #"\Microsoft\Windows\RecoveryEnvironment\VerifyWinRE"

            #"\Microsoft\Windows\Registry\RegIdleBackup"

            #"\Microsoft\Windows\RemoteAssistance\RemoteAssistanceTask"

            #"\Microsoft\Windows\RemovalTools\MRT_HB"

            #"\Microsoft\Windows\Servicing\StartComponentCleanup"

            #"\Microsoft\Windows\SettingSync\NetworkStateChangeTask"

            #"\Microsoft\Windows\Shell\CreateObjectTask"
            #"\Microsoft\Windows\Shell\FamilySafetyMonitor"
            #"\Microsoft\Windows\Shell\FamilySafetyRefresh"
            #"\Microsoft\Windows\Shell\IndexerAutomaticMaintenance"

            #"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTask"
            #"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskLogon"
            #"\Microsoft\Windows\SoftwareProtectionPlatform\SvcRestartTaskNetwork"

            #"\Microsoft\Windows\SpacePort\SpaceAgentTask"

            #"\Microsoft\Windows\Sysmain\HybridDriveCachePrepopulate"
            #"\Microsoft\Windows\Sysmain\HybridDriveCacheRebalance"
            #"\Microsoft\Windows\Sysmain\ResPriStaticDbSync"
            #"\Microsoft\Windows\Sysmain\WsSwapAssessmentTask"

            #"\Microsoft\Windows\SystemRestore\SR"

            #"\Microsoft\Windows\Task Manager\Interactive"

            #"\Microsoft\Windows\TextServicesFramework\MsCtfMonitor"

            #"\Microsoft\Windows\Time Synchronization\ForceSynchronizeTime"
            #"\Microsoft\Windows\Time Synchronization\SynchronizeTime"

            #"\Microsoft\Windows\Time Zone\SynchronizeTimeZone"

            #"\Microsoft\Windows\TPM\Tpm-HASCertRetr"
            #"\Microsoft\Windows\TPM\Tpm-Maintenance"

            #"\Microsoft\Windows\UpdateOrchestrator\Maintenance Install"
            #"\Microsoft\Windows\UpdateOrchestrator\Policy Install"
            #"\Microsoft\Windows\UpdateOrchestrator\Reboot"
            #"\Microsoft\Windows\UpdateOrchestrator\Resume On Boot"
            #"\Microsoft\Windows\UpdateOrchestrator\Schedule Scan"
            #"\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_Display"
            #"\Microsoft\Windows\UpdateOrchestrator\USO_UxBroker_ReadyToReboot"

            #"\Microsoft\Windows\UPnP\UPnPHostConfig"

            #"\Microsoft\Windows\User Profile Service\HiveUploadTask"

            #"\Microsoft\Windows\WCM\WiFiTask"

            #"\Microsoft\Windows\WDI\ResolutionHost"

            "\Microsoft\Windows\Windows Defender\Windows Defender Cache Maintenance"
            "\Microsoft\Windows\Windows Defender\Windows Defender Cleanup"
            "\Microsoft\Windows\Windows Defender\Windows Defender Scheduled Scan"
            "\Microsoft\Windows\Windows Defender\Windows Defender Verification"

            "\Microsoft\Windows\Windows Error Reporting\QueueReporting"

            #"\Microsoft\Windows\Windows Filtering Platform\BfeOnServiceStartTypeChange"

            #"\Microsoft\Windows\Windows Media Sharing\UpdateLibrary"

            #"\Microsoft\Windows\WindowsColorSystem\Calibration Loader"

            #"\Microsoft\Windows\WindowsUpdate\Automatic App Update"
            #"\Microsoft\Windows\WindowsUpdate\Scheduled Start"
            #"\Microsoft\Windows\WindowsUpdate\sih"
            #"\Microsoft\Windows\WindowsUpdate\sihboot"

            #"\Microsoft\Windows\Wininet\CacheTask"

            #"\Microsoft\Windows\WOF\WIM-Hash-Management"
            #"\Microsoft\Windows\WOF\WIM-Hash-Validation"

            #"\Microsoft\Windows\Work Folders\Work Folders Logon Synchronization"
            #"\Microsoft\Windows\Work Folders\Work Folders Maintenance Work"

            #"\Microsoft\Windows\Workplace Join\Automatic-Device-Join"

            #"\Microsoft\Windows\WS\License Validation"
            #"\Microsoft\Windows\WS\WSTask"

            # Scheduled tasks which cannot be disabled
            #"\Microsoft\Windows\Device Setup\Metadata Refresh"
            #"\Microsoft\Windows\SettingSync\BackgroundUploadTask"
        )

        foreach ($task in $tasks) {
            $parts = $task.split('\')
            $name = $parts[-1]
            $path = $parts[0..($parts.length - 2)] -join '\'

            Disable-ScheduledTask -TaskName "$name" -TaskPath "$path" -ErrorAction SilentlyContinue
        }

        #Disables scheduled tasks that are considered unnecessary 
        Write-Information "Disabling scheduled tasks"
        Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask
        Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask
        Get-ScheduledTask  Consolidator | Disable-ScheduledTask
        Get-ScheduledTask  UsbCeip | Disable-ScheduledTask
        Get-ScheduledTask  DmClient | Disable-ScheduledTask
        Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask
    
        @(
            
            #Remove Background Tasks
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
            #Windows File
            "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
            #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
            #Scheduled Tasks to delete
            "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
            #Windows Protocol Keys
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
            "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
            #Windows Share Target
            "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        ) | ForEach-Object {
            Remove-Item $_ -Recurse
        }

    }
    
}


