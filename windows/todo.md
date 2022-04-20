Set up Console Host
    https://devblogs.microsoft.com/commandline/understanding-windows-console-host-settings/

Set up terminal ( colors, profiles, aliases, Z )
    https://www.youtube.com/watch?v=5-aK2_WwrmM

Set up Intelli-J linkage

Windows Look and feels
    Set up Windows Night Light
    Remove Windows bar @ second screen
        
    !: Pin at taskbar
    Set Default Applications

    Show Keyboard-Chooser
        . Remove ctrl + shift choosing keyboard ( windows + alt only )
        ( Better keyboard, overall)



Better Tuning
    Optimize-Services
    Optimize-WindowsDefender
    Optimize-BackgroundTasks
    Better Hosts File     


Chrome
    Install Extensions
        NewTab-Redirect
        MarkDownload
        PoperBlocker

        Vimium
        Time Your Web Tracker
        Dashlane
        JsonViewer
        uBlock Origin
        New Tab Update
            file://C:\Users\Mateus\Downloads\home\index.html
            

Better Hosts / Ip handling
Remove DeliveryOptimization
Analyze recorded PML

Set up themes.; 
    https://docs.microsoft.com/en-us/windows/win32/controls/themesfileformat-overview#creating-a-theme-file

    C:\Users\Default\AppData\Local\Microsoft\Windows\Shell
    New-Item "C:\temp" -Type Directory  
    Export-StartLayout -Path "C:\temp\DefaultLayout.xml"  

Set up this git repository properly ( submodules + optional privates )


# Interesting Registries
%
Computer\HKEY_CURRENT_USER\AppEvents\EventLabels
Computer\HKEY_CURRENT_USER\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe
Computer\HKEY_CURRENT_USER\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe
Computer\HKEY_CURRENT_USER\Control Panel\Accessibility\Keyboard Response
Computer\HKEY_CURRENT_USER\Control Panel\Accessibility\StickyKeys
Computer\HKEY_CURRENT_USER\Control Panel\Accessibility\ToggleKeys
Computer\HKEY_CURRENT_USER\Control Panel\Appearance\Schemes
Computer\HKEY_CURRENT_USER\Control Panel\Colors
Computer\HKEY_CURRENT_USER\Control Panel\Cursors
Computer\HKEY_CURRENT_USER\Control Panel\Desktop
Computer\HKEY_CURRENT_USER\Control Panel\Input Method
Computer\HKEY_CURRENT_USER\Control Panel\International
Computer\HKEY_CURRENT_USER\Control Panel\International\Geo
Computer\HKEY_CURRENT_USER\Control Panel\Mouse
Computer\HKEY_CURRENT_USER\Environment
Computer\HKEY_CURRENT_USER\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\CTF\Assemblies\0x00000409\{34745C63-B2F0-4784-8B67-5E12C8701A31}\KeyboardLayout
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Edge\Extensions
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Input\TypingInsights
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\InputPersonalization
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\OneDrive
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\HostActivityManager
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows NT\CurrentVersion\TileDataModel\Migration
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows Search
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Cortana
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SearchPlatform\Preferences
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Run
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Search
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\SearchSettings
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Shell Extensions\Cached
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StartLayout
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\StorageSense\SuggestedFolders
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\History
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize
Computer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\Shell\Bags\1\Desktop
Computer\HKEY_CURRENT_USER\Volatile Environment
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Clients
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\DefaultUserEnvironment
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DataCollection
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\DDDS
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EventSystem
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\FuzzyDS
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\IHDS
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\DataSources\FluencyDS
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\HwkSettings
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Input\Settings
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InputMethod\Settings\CHS
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\InputPersonalization
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MTFFuzzyFactors
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MTFInputType
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MTFKeyboardMappings
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\3\PowerShellEngine
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SchedulingAgent
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\SystemSettings\SettingId
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Tracing
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Defender
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\ActionCenter\Quick Actions\All
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\CloudExperienceHost\Broker\ElevatedClsids\{1ee026d0-f551-4c71-aea2-f9897b159eaf}
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderTypes
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\KindMap
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Power
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartMenu\StartPanel\HoverOpen
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\FileExplorer\Config
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\RegisteredApplications
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\FilePicker
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\Microsoft\PowerShell\3
Explorer\Advanced\ShowTaskViewButton
HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.Windows.Search_cw5n1h2txyewy\HAM\AUI\ShellFeedsUI
HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify\IconStreams
puter\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies




# 
#

What is 
HKLM\System\CurrentControlSet\Services\IpxlatCfgSvc


What is
HKLM\Software\Microsoft\PolicyManager\default\Start\NoPinningToTaskbar


What is
HKLM\Software\Microsoft\PolicyManager\default\SmartScreen\EnableSmartScreenInShell



C:\Windows\System32\WindowsPowerShell\v1.0\desktop.ini
HKLM\SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers\TransparentEnabled
HKLM\System\CurrentControlSet\Control\FileSystem\LongPathsEnabled
https://communary.net/2016/04/03/how-to-add-more-fonts-to-the-console/
omputer\HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize



HKCR\Directory\shell\Powershell\command\(Default)  ; Type: REG_SZ, Length: 126, Data: powershell.exe -noexit -command Set-Location -literalPath '%V'
    -> This regiestry in specific seems to be write-protected.
    -> Can be bypassed by taking ownership off trusted installer

HKEY_CLASSES_ROOT\exefile\shell\runas\command ; "%1" %*
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PowerShell.exe\(Default) ; Type: REG_EXPAND_SZ, Length: 120, Data: %SystemRoot%\system32\WindowsPowerShell\v1.0\PowerShell.exe


Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PowerShell.exe
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\3
Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PowerShell.exe
HKCR\Directory\shell\Powershell\ExplorerCommandHandler





When launching as admin, Need to Remove shortcut pointed by HKLM\SOFTWARE\Microsoft\PowerShell\3\ConsoleHostShortcutTarget.
    By default, this seems to be
        %AppData%\Microsoft\Windows\Start Menu\Programs\Windows PowerShell\Windows PowerShell.lnk
    
    This makes the system look for the executable elsewhere - 
        Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\PowerShell.exe
        
    We can make this second registry path point to where we want.
        C:\Program Files\Alacritty\alacritty.exe
        
    
    Using the normal  ( non admin ) method, it takes its parameters from the registry.
        HKCR\Directory\shell\Powershell\command\(Default)
            Usually, it has powershell.exe -no-exit -command Set-Location -literalPath %V
            However, we can make it powershell.exe --working-directory %V -> This makes it a alacritty-compatible command. 

    
    Haven't been able to find a similar location for the admin one. 





\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PolicyManager\default\SmartScreen
HKCU\Software\Classes\AllSyncRootObjects\shell\ShellPlaceholderLinkVerb




Push-Location 
Set-Location HKCU:\Console 
New-Item ".\%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe" 
Set-Location ".\%SystemRoot%_system32_WindowsPowerShell_v1.0_powershell.exe"

New-ItemProperty . ColorTable00 -type DWORD -value 0×00562401 
New-ItemProperty . ColorTable07 -type DWORD -value 0x00f0edee 
New-ItemProperty . FaceName -type STRING -value "Lucida Console" 
New-ItemProperty . FontFamily -type DWORD -value 0×00000036 
New-ItemProperty . FontSize -type DWORD -value 0x000c0000 
New-ItemProperty . FontWeight -type DWORD -value 0×00000190 
New-ItemProperty . HistoryNoDup -type DWORD -value 0×00000000 
New-ItemProperty . QuickEdit -type DWORD -value 0×00000001 
New-ItemProperty . ScreenBufferSize -type DWORD -value 0x0bb80078 
New-ItemProperty . WindowSize -type DWORD -value 0×00320078 
Pop-Location
