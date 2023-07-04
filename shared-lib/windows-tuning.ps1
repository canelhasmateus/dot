
    
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




