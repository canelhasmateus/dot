function InstallWsl {
    Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName Microsoft-Windows-Subsystem-Linux  
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    wsl --install
}


function Install-WSL2 {
    
    $WSL_URI = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    $Desktop = [Environment]::GetFolderPath( "Desktop" ) 
    $WSL_MSI = Join-Path $Desktop "/WSL.msi" 
    Invoke-RestMethod -Uri   $WSL_URI -OutFile $WSL_MSI
    
    #Not Working yet.
    Invoke-Expression "$WSL_MSI /passive /norestart"
    wsl --set-default-version 2
    # Remove-Item $WSL_MSI -Force

}

