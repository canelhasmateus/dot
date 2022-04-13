$RegistryModule = Join-Path $PSScriptRoot "registry.ps1"
. $RegistryModule

function Flatten ( $Array ) {
        
    return $Array | ForEach-Object {
        $_
    }

}
function Update-Privilege {
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

#
#
#

function Disable-Services( $List) {
    $Flattened = Flatten $List
    Update-Privileges
    
    $Flattened | ForEach-Object {
         
        $ServiceName = $_
        
        $Service = Get-Service -Name $serviceName 
        $PreviousStatus = $Service.StartType
        
        if ( $PreviousStatus -ne "Disabled" ) {
            $Service | Set-Service -StartupType Disabled -PassThru | Stop-Service -ErrorAction SilentlyContinue
            $Service = Get-Service -Name $serviceName  
            Start-Sleep -Milliseconds 200
        }
        
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
        if ( $PreviousStatus -ne "Enabled" ) {
            $Service | Set-Service -StartupType Automatic -PassThru | Start-Service -ErrorAction SilentlyContinue
            $Service = Get-Service -Name $serviceName  
            Start-Sleep -Milliseconds 200
        }
        

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
        "AppXSvc" # AppX Deployment Service (AppXSVC)
        "CDPUserSvc_57b89"
        "CoreMessagingRegistrar" #  CoreMessaging
        "DcomLaunch" #  DCOM Server Process Launcher
        "Dnscache" #  DNS Client
        "DoSvc" # Delivery Optimization
        "LSM" #  Local Session Manager
        "LxssManager" #  LxssManager
        "mpssvc" # Windows Defender Firewall
        "RpcEptMapper" # RPC Endpoint Mapper
        "RpcSs" # Remote Procedure Call (RPC)
        "SecurityHealthService" # Windows Security Service
        "SgrmBroker" # System Guard Runtime Monitor Broker
        "StateRepository" # State Repository Service
        "SystemEventsBroker" # System Events Broker
        "TimeBrokerSvc" # Time Broker
        "WdNisSvc" # Microsoft Defender Antivirus Network Inspection Service
        "WinDefend" # Microsoft Defender Antivirus Service
        "WinHttpAutoProxySvc" # WinHTTP Web Proxy Auto-Discovery Service
        "wscsvc" # Security Center
    )

    $Manual = @( 
        
        "DeviceAssociationService" #  Device Association Service
        "DisplayEnhancementService" #  Display Enhancement Service
        "FontCache3.0.0.0" # Windows Presentation Foundation Font Cache 3.0.0.0
        "hidserv" #  Human Interface Device Service
        "hns" #  Host Network Service
        "HvHost" #  HV Host Service
        "KeyIso" #  CNG Key Isolation
        "netprofm" #  Network List Service
        "nvagent" #  Network Virtualization Service
        "SharedAccess" #  Internet Connection Sharing (ICS)
        "SstpSvc" # Secure Socket Tunneling Protocol Service
        
    )
    $Using = @( 
        "Audiosrv" #  Windows Audio
        "com.docker.service" #  Docker Desktop Service
        "LanmanServer" # Server ; Required by docker
        "LanmanWorkstation" # Workstation ; Required by docker
        "Wcmsvc" # Windows Connection Manager ; Required for internet        
        "Winmgmt" # Windows Management Instrumentation ; Required by Restart-Computer and probably others
    )
    $Investigate = @(
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
        "NetTcpPortSharing"                        # Net.Tcp Port Sharing Service
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
    
}

