$RegistryModule = Join-Path $PSScriptRoot "registry.ps1"
. $RegistryModule

function Update-Privileges {
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
function Flatten ( $Array ) {
        
    return $Array | ForEach-Object {
        $_
    }

}
function Disable-Tasks( $List ) {
    $List = Flatten $List
    Update-Privileges

    $List | ForEach-Object {
        $Name = $_.Name
        $Path = $_.Path

        $Task = Get-ScheduledTask -TaskName $Name  -TaskPath $Path -ErrorAction SilentlyContinue
        $PreviousStatus = $Task.State
        
        if ( $PreviousStatus -ne 'Disabled') {
            
            $Task | Disable-ScheduledTask -ErrorAction SilentlyContinue *> $null
            $Task = Get-ScheduledTask -TaskName $Name  -TaskPath $Path -ErrorAction SilentlyContinue
            Start-Sleep -Milliseconds 200

        }
        
        $CurrentStatus = $Task.State


        return [PSCustomObject]@{
            Success        = $CurrentStatus -eq 'Disabled'
            PreviousStatus = $PreviousStatus
            CurrentStatus  = $CurrentStatus
            Name           = $Name
            Path           = $Path
        }

    } | Format-Table -AutoSize
}
function Optimize-BackgroundTasks {
    
    $NoPermission = @( 
        @{
            path = "\Microsoft\Windows\BitLocker\"
            name = "BitLocker Encrypt All Drives"
        }
        @{
            path = "\Microsoft\Windows\BitLocker\"
            name = "BitLocker MDM policy Refresh"
        }
        @{
            path = "\Microsoft\Windows\Chkdsk\"
            name = "SyspartRepair"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "HandleCommand"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "HandleWnsCommand"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "LocateCommandUserSession"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterDeviceAccountChange"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterDeviceLocationRightsChange"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterDevicePeriodic24"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterDevicePolicyChange"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterDeviceProtectionStateChanged"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterDeviceSettingChange"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterDeviceWnsFallback"
        }
        @{
            path = "\Microsoft\Windows\DeviceDirectoryClient\"
            name = "RegisterUserDevice"
        }
        @{
            path = "\Microsoft\Windows\EDP\"
            name = "EDP App Launch Task"
        }
        @{
            path = "\Microsoft\Windows\EDP\"
            name = "EDP Auth Task"
        }
        @{
            path = "\Microsoft\Windows\EDP\"
            name = "EDP Inaccessible Credentials Task"
        }
        @{
            path = "\Microsoft\Windows\SettingSync\"
            name = "BackgroundUploadTask"
        }
        @{
            path = "\Microsoft\Windows\Shell\"
            name = "UpdateUserPictureTask"
        }
        @{
            path = "\Microsoft\Windows\UpdateOrchestrator\"
            name = "Report policies"
        }
        @{
            path = "\Microsoft\Windows\UpdateOrchestrator\"
            name = "Schedule Scan"
        }
        @{
            path = "\Microsoft\Windows\UpdateOrchestrator\"
            name = "Schedule Scan Static Task"
        }
        @{
            path = "\Microsoft\Windows\UpdateOrchestrator\"
            name = "Schedule Work"
        }
        @{
            path = "\Microsoft\Windows\UpdateOrchestrator\"
            name = "UpdateModelTask"
        }
        @{
            path = "\Microsoft\Windows\UpdateOrchestrator\"
            name = "USO_UxBroker"
        }
        @{
            path = "\Microsoft\Windows\Active Directory Rights Management Services Client"
            name = "AD RMS Rights Policy Template Management (Manual)"
        }
        @{
            path = "\Microsoft\Windows\EDP\"
            name = "StorageCardEncryption Task"
        }
        @{
            path = "\Microsoft\Windows\Wininet\"
            name = "CacheTask"
        }

    )
    
    $Investigate = @( 
        @{
            path = "\"
            name = "OneDrive Reporting Task-S-1-5-21-1131998382-2623026393-1346818710-1001"
        }
        @{
            path = "\"
            name = "OneDrive Standalone Update Task-S-1-5-21-1131998382-2623026393-1346818710-"
        }
        @{
            path = "\Microsoft\Windows\BrokerInfrastructure\"
            name = "BgTaskRegistrationMaintenanceTask"
        }
        @{
            path = "\Microsoft\Windows\CertificateServicesClient\"
            name = "AikCertEnrollTask"
        }
        @{
            path = "\Microsoft\Windows\CertificateServicesClient\"
            name = "CryptoPolicyTask"
        }
        @{
            path = "\Microsoft\Windows\CertificateServicesClient\"
            name = "KeyPreGenTask"
        }
        @{
            path = "\Microsoft\Windows\CertificateServicesClient\"
            name = "SystemTask"
        }
        @{
            path = "\Microsoft\Windows\CertificateServicesClient\"
            name = "UserTask"
        }
        @{
            path = "\Microsoft\Windows\CertificateServicesClient\"
            name = "UserTask-Roam"
        }
        @{
            path = "\Microsoft\Windows\Device Information\"
            name = "Device"
        }
        @{
            path = "\Microsoft\Windows\Device Information\"
            name = "Device User"
        }
        @{
            path = "\Microsoft\Windows\Device Setup\"
            name = "Metadata Refresh"
        }
        
        @{
            path = "\Microsoft\Windows\DiskCleanup\"
            name = "SilentCleanup"
        }
        @{
            path = "\Microsoft\Windows\Input\"
            name = "LocalUserSyncDataAvailable"
        }
        @{
            path = "\Microsoft\Windows\Input\"
            name = "MouseSyncDataAvailable"
        }
        @{
            path = "\Microsoft\Windows\Input\"
            name = "PenSyncDataAvailable"
        }
        @{
            path = "\Microsoft\Windows\Input\"
            name = "TouchpadSyncDataAvailable"
        }
        @{
            path = "\Microsoft\Windows\InstallService\"
            name = "ScanForUpdates"
        }
        @{
            path = "\Microsoft\Windows\InstallService\"
            name = "ScanForUpdatesAsUser"
        }
        @{
            path = "\Microsoft\Windows\InstallService\"
            name = "SmartRetry"
        }
        @{
            path = "\Microsoft\Windows\MUI\"
            name = "LPRemove"
        }
        @{
            path = "\Microsoft\Windows\Multimedia\"
            name = "SystemSoundsService"
        }
        @{
            path = "\Microsoft\Windows\NetTrace\"
            name = "GatherNetworkInfo"
        }
        @{
            path = "\Microsoft\Windows\NlaSvc\"
            name = "WiFiTask"
        }
        @{
            path = "\Microsoft\Windows\Registry\"
            name = "RegIdleBackup"
        }
        @{
            path = "\Microsoft\Windows\Shell\"
            name = "IndexerAutomaticMaintenance"
        }
        @{
            path = "\Microsoft\Windows\Sysmain\"
            name = "WsSwapAssessmentTask"
        }
        @{
            path = "\Microsoft\Windows\SystemRestore\"
            name = "SR"
        }
        @{
            path = "\Microsoft\Windows\Time Synchronization\"
            name = "ForceSynchronizeTime"
        }
        @{
            path = "\Microsoft\Windows\Time Synchronization\"
            name = "SynchronizeTime"
        }
        @{
            path = "\Microsoft\Windows\Time Zone\"
            name = "SynchronizeTimeZone"
        }
        @{
            path = "\Microsoft\Windows\USB\"
            name = "Usb-Notifications"
        }
        @{
            path = "\Microsoft\Windows\WCM\"
            name = "WiFiTask"
        }
        @{
            path = "\Microsoft\Windows\WDI\"
            name = "ResolutionHost"
        }

    )
    
    $Tasks = @(
        @{
            path = "\"
            name = "MicrosoftEdgeShadowStackRollbackTask"
        }
        @{
            path = "\"
            name = "MicrosoftEdgeUpdateTaskMachineCore"
        }
        @{
            path = "\"
            name = "MicrosoftEdgeUpdateTaskMachineUA"
        }
        
        @{
            path = "\Microsoft\Windows\.NET Framework\"
            name = ".NET Framework NGEN v4.0.30319"
        }
        @{
            path = "\Microsoft\Windows\.NET Framework\"
            name = ".NET Framework NGEN v4.0.30319 64"
        }
        
        @{
            path = "\Microsoft\Windows\AppID\"
            name = "EDP Policy Manager"
        }
        @{
            path = "\Microsoft\Windows\AppID\"
            name = "VerifiedPublisherCertStoreCheck"
        }
        @{
            path = "\Microsoft\Windows\Application Experience\"
            name = "Microsoft Compatibility Appraiser"
        }
        @{
            path = "\Microsoft\Windows\Application Experience\"
            name = "PcaPatchDbTask"
        }
        @{
            path = "\Microsoft\Windows\Application Experience\"
            name = "ProgramDataUpdater"
        }
        @{
            path = "\Microsoft\Windows\Application Experience\"
            name = "StartupAppTask"
        }
        @{
            path = "\Microsoft\Windows\ApplicationData\"
            name = "appuriverifierdaily"
        }
        @{
            path = "\Microsoft\Windows\ApplicationData\"
            name = "appuriverifierinstall"
        }
        @{
            path = "\Microsoft\Windows\ApplicationData\"
            name = "CleanupTemporaryState"
        }
        @{
            path = "\Microsoft\Windows\ApplicationData\"
            name = "DsSvcCleanup"
        }
        @{
            path = "\Microsoft\Windows\AppListBackup\"
            name = "Backup"
        }
        @{
            path = "\Microsoft\Windows\Autochk\"
            name = "Proxy"
        }
        
        @{
            path = "\Microsoft\Windows\Bluetooth\"
            name = "UninstallDeviceTask"
        }
        
        @{
            path = "\Microsoft\Windows\Chkdsk\"
            name = "ProactiveScan"
        }
        
        @{
            path = "\Microsoft\Windows\CloudExperienceHost\"
            name = "CreateObjectTask"
        }
        @{
            path = "\Microsoft\Windows\Customer Experience Improvement Program\"
            name = "Consolidator"
        }
        @{
            path = "\Microsoft\Windows\Customer Experience Improvement Program\"
            name = "UsbCeip"
        }
        @{
            path = "\Microsoft\Windows\Data Integrity Scan\"
            name = "Data Integrity Check And Scan"
        }
        @{
            path = "\Microsoft\Windows\Data Integrity Scan\"
            name = "Data Integrity Scan"
        }
        @{
            path = "\Microsoft\Windows\Data Integrity Scan\"
            name = "Data Integrity Scan for Crash Recovery"
        }
        @{
            path = "\Microsoft\Windows\Defrag\"
            name = "ScheduledDefrag"
        }
        
        @{
            path = "\Microsoft\Windows\Diagnosis\"
            name = "RecommendedTroubleshootingScanner"
        }
        @{
            path = "\Microsoft\Windows\Diagnosis\"
            name = "Scheduled"
        }
        @{
            path = "\Microsoft\Windows\DirectX\"
            name = "DirectXDatabaseUpdater"
        }
        @{
            path = "\Microsoft\Windows\DirectX\"
            name = "DXGIAdapterCache"
        }
        
        @{
            path = "\Microsoft\Windows\DiskDiagnostic\"
            name = "Microsoft-Windows-DiskDiagnosticDataCollector"
        }
        @{
            path = "\Microsoft\Windows\DiskFootprint\"
            name = "Diagnostics"
        }
        @{
            path = "\Microsoft\Windows\DiskFootprint\"
            name = "StorageSense"
        }
        @{
            path = "\Microsoft\Windows\DUSM\"
            name = "dusmtask"
        }
        
        
        @{
            path = "\Microsoft\Windows\ExploitGuard\"
            name = "ExploitGuard MDM policy Refresh"
        }
        @{
            path = "\Microsoft\Windows\Feedback\Siuf\"
            name = "DmClient"
        }
        @{
            path = "\Microsoft\Windows\Feedback\Siuf\"
            name = "DmClientOnScenarioDownload"
        }
        @{
            path = "\Microsoft\Windows\FileHistory\"
            name = "File History (maintenance mode)"
        }
        @{
            path = "\Microsoft\Windows\Flighting\FeatureConfig\"
            name = "ReconcileFeatures"
        }
        @{
            path = "\Microsoft\Windows\Flighting\FeatureConfig\"
            name = "UsageDataFlushing"
        }
        @{
            path = "\Microsoft\Windows\Flighting\FeatureConfig\"
            name = "UsageDataReporting"
        }
        @{
            path = "\Microsoft\Windows\Flighting\OneSettings\"
            name = "RefreshCache"
        }
        @{
            path = "\Microsoft\Windows\HelloFace\"
            name = "FODCleanupTask"
        }
        
        @{
            path = "\Microsoft\Windows\International\"
            name = "Synchronize Language Settings"
        }
        @{
            path = "\Microsoft\Windows\LanguageComponentsInstaller\"
            name = "Installation"
        }
        @{
            path = "\Microsoft\Windows\LanguageComponentsInstaller\"
            name = "ReconcileLanguageResources"
        }
        @{
            path = "\Microsoft\Windows\License Manager\"
            name = "TempSignedLicenseExchange"
        }
        @{
            path = "\Microsoft\Windows\Location\"
            name = "Notifications"
        }
        @{
            path = "\Microsoft\Windows\Location\"
            name = "WindowsActionDialog"
        }
        @{
            path = "\Microsoft\Windows\Maintenance\"
            name = "WinSAT"
        }
        @{
            path = "\Microsoft\Windows\Management\Provisioning\"
            name = "Cellular"
        }
        @{
            path = "\Microsoft\Windows\Management\Provisioning\"
            name = "Logon"
        }
        @{
            path = "\Microsoft\Windows\Maps\"
            name = "MapsToastTask"
        }
        @{
            path = "\Microsoft\Windows\MemoryDiagnostic\"
            name = "ProcessMemoryDiagnosticEvents"
        }
        @{
            path = "\Microsoft\Windows\MemoryDiagnostic\"
            name = "RunFullMemoryDiagnostic"
        }
        @{
            path = "\Microsoft\Windows\Mobile Broadband Accounts\"
            name = "MNO Metadata Parser"
        }
        
        @{
            path = "\Microsoft\Windows\PI\"
            name = "Secure-Boot-Update"
        }
        @{
            path = "\Microsoft\Windows\PI\"
            name = "Sqm-Tasks"
        }
        @{
            path = "\Microsoft\Windows\Plug and Play\"
            name = "Device Install Group Policy"
        }
        @{
            path = "\Microsoft\Windows\Plug and Play\"
            name = "Device Install Reboot Required"
        }
        @{
            path = "\Microsoft\Windows\Plug and Play\"
            name = "Sysprep Generalize Drivers"
        }
        @{
            path = "\Microsoft\Windows\Power Efficiency Diagnostics\"
            name = "AnalyzeSystem"
        }
        @{
            path = "\Microsoft\Windows\Printing\"
            name = "EduPrintProv"
        }
        @{
            path = "\Microsoft\Windows\PushToInstall\"
            name = "LoginCheck"
        }
        @{
            path = "\Microsoft\Windows\PushToInstall\"
            name = "Registration"
        }
        @{
            path = "\Microsoft\Windows\Ras\"
            name = "MobilityManager"
        }
        @{
            path = "\Microsoft\Windows\RecoveryEnvironment\"
            name = "VerifyWinRE"
        }
        
        @{
            path = "\Microsoft\Windows\RemoteAssistance\"
            name = "RemoteAssistanceTask"
        }
        @{
            path = "\Microsoft\Windows\RetailDemo\"
            name = "CleanupOfflineContent"
        }
        @{
            path = "\Microsoft\Windows\Servicing\"
            name = "StartComponentCleanup"
        }
        
        @{
            path = "\Microsoft\Windows\SettingSync\"
            name = "NetworkStateChangeTask"
        }
        @{
            path = "\Microsoft\Windows\Shell\"
            name = "CreateObjectTask"
        }
        @{
            path = "\Microsoft\Windows\Shell\"
            name = "FamilySafetyMonitor"
        }
        @{
            path = "\Microsoft\Windows\Shell\"
            name = "FamilySafetyRefreshTask"
        }
        
        @{
            path = "\Microsoft\Windows\SoftwareProtectionPlatform\"
            name = "SvcRestartTask"
        }
        @{
            path = "\Microsoft\Windows\SpacePort\"
            name = "SpaceAgentTask"
        }
        @{
            path = "\Microsoft\Windows\SpacePort\"
            name = "SpaceManagerTask"
        }
        @{
            path = "\Microsoft\Windows\Speech\"
            name = "SpeechModelDownloadTask"
        }
        @{
            path = "\Microsoft\Windows\StateRepository\"
            name = "MaintenanceTasks"
        }
        @{
            path = "\Microsoft\Windows\Storage Tiers Management\"
            name = "Storage Tiers Management Initialization"
        }
        @{
            path = "\Microsoft\Windows\Subscription\"
            name = "EnableLicenseAcquisition"
        }
        @{
            path = "\Microsoft\Windows\Sysmain\"
            name = "ResPriStaticDbSync"
        }
        
        @{
            path = "\Microsoft\Windows\Task Manager\"
            name = "Interactive"
        }
        @{
            path = "\Microsoft\Windows\TextServicesFramework\"
            name = "MsCtfMonitor"
        }
        
        @{
            path = "\Microsoft\Windows\TPM\"
            name = "Tpm-HASCertRetr"
        }
        @{
            path = "\Microsoft\Windows\TPM\"
            name = "Tpm-Maintenance"
        }
        
        @{
            path = "\Microsoft\Windows\UPnP\"
            name = "UPnPHostConfig"
        }
        
        @{
            path = "\Microsoft\Windows\Windows Defender\"
            name = "Windows Defender Cache Maintenance"
        }
        @{
            path = "\Microsoft\Windows\Windows Defender\"
            name = "Windows Defender Cleanup"
        }
        @{
            path = "\Microsoft\Windows\Windows Defender\"
            name = "Windows Defender Scheduled Scan"
        }
        @{
            path = "\Microsoft\Windows\Windows Defender\"
            name = "Windows Defender Verification"
        }
        @{
            path = "\Microsoft\Windows\Windows Error Reporting\"
            name = "QueueReporting"
        }
        @{
            path = "\Microsoft\Windows\Windows Filtering Platform\"
            name = "BfeOnServiceStartTypeChange"
        }
        @{
            path = "\Microsoft\Windows\Windows Media Sharing\"
            name = "UpdateLibrary"
        }
        @{
            path = "\Microsoft\Windows\WindowsColorSystem\"
            name = "Calibration Loader"
        }
        @{
            path = "\Microsoft\Windows\WindowsUpdate\"
            name = "Scheduled Start"
        }
        
        @{
            path = "\Microsoft\Windows\WlanSvc\"
            name = "CDSSync"
        }
        @{
            path = "\Microsoft\Windows\WOF\"
            name = "WIM-Hash-Management"
        }
        @{
            path = "\Microsoft\Windows\Work Folders\"
            name = "Work Folders Logon Synchronization"
        }
        @{
            path = "\Microsoft\Windows\Work Folders\"
            name = "Work Folders Maintenance Work"
        }
        @{
            path = "\Microsoft\Windows\WwanSvc\"
            name = "NotificationTask"
        }
        @{
            path = "\Microsoft\Windows\WwanSvc\"
            name = "OobeDiscovery"
        }

    )

    
    Disable-Tasks $Tasks
    
    # @(
            
    #     #Remove Background Tasks
    #     "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
    #     "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    #     "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
    #     "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    #     "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    #     "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
    #     #Windows File
    #     "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
    #     #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
    #     "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
    #     "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    #     "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    #     "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    #     "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
    #     #Scheduled Tasks to delete
    #     "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
    #     #Windows Protocol Keys
    #     "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    #     "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
    #     "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
    #     "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
    #     #Windows Share Target
    #     "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    # ) | ForEach-Object {
    #     Remove-Item $_ -Recurse
    # }

}
