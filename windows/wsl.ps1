
workflow Install-WSL {

Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName Microsoft-Windows-Subsystem-Linux  
wsl --install

Restart-Computer -Wait


$WSL_URI = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
$WSL_MSI = Resolve-Path "./WSL.msi"
Invoke-RestMethod -Uri   $WSL_URI -OutFile $WSL_MSI


dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
msiexec.exe /I $WSL_MSI /QN

wsl --set-default-version 2

Remove-Item $WSL_MSI
Unregister-ScheduledJob -Name $Resumer
Restart-Computer -Wait

}

function Remove-Resumer {
    [cmdletbinding()]

    Param(
    [string]$Name
    )

$Job = Get-ScheduledJob -Name $Name -ErrorAction SilentlyContinue

if ($Job -ne $null ) {
    Unregister-ScheduledJob $Name -Confirm:$false 
    
}

$Task = Get-ScheduledTask -TaskName $Name

if ($Task -ne $null ) {
    Unregister-ScheduledTask -TaskName $Name 
}



}

function Create-Resumer {
    [cmdletbinding()]

    param([string]$Name,
     [scriptblock]$Script
     )


$Options = New-ScheduledJobOption -StartIfOnBattery -RunElevated;
$Trigger = New-JobTrigger -AtStartup;

Register-ScheduledJob -Name $Name -Trigger $Trigger -ScheduledJobOption $Options -ScriptBlock $Script

}

# Some Vars. https://stackoverflow.com/questions/40569045/register-scheduledjob-as-the-system-account-without-having-to-pass-in-credentia
$Resumer = "ResumeSuspended"
$NT = "NT AUTHORITY\SYSTEM"
$TaskDir = "\Microsoft\Windows\PowerShell\ScheduledJobs"


# Create A Scheduled Job At StartUp. It will run elevated and Get the suspended Workflow, and resume it.
# An System Principal is created and assigned to the Job. This is necessary for sufficient permissions.
Remove-Resumer -Name $Resumer
Create-Resumer -Name $Resumer -Script {
     Import-Module PSWorkflow; 
     Get-Job -Name Install-WSL | Write-Host
     Get-Job -Name Install-WSL |  Resume-Job
    }


# $Principal = New-ScheduledTaskPrincipal -LogonType ServiceAccount -RunLevel Highest -UserID $NT;
# Set-ScheduledTask -TaskPath $TaskDir -TaskName $Resumer -Principal $principal


Install-WSL -JobName Install-WSL
