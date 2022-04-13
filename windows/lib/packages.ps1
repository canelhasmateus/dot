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
