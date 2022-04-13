function Optimize-Bloat {

    $ServicesModule = Join-Path $PSScriptRoot "/lib/services.ps1"
    . $ServicesModule
    
    Optimize-Services
    Optimize-WindowsDefender

    $PackagesModule = Join-Path $PSScriptRoot "/lib/packages.ps1"
    . $PackagesModule

    Optimize-AppxPackages
    
    

    $TasksModule = Join-Path $PSScriptRoot "/lib/tasks.ps1"
    . $TasksModule

    Optimize-BackgroundTasks

    $NetworkModule = Join-Path $PSScriptRoot "/lib/network.ps1"
    . $NetworkModule
    Optimize-Privacy
    Optimize-NetworkTraffic
    
    #Optimize-Others    
    #$Reg = Join-Path $PSScriptRoot "lib/ram.reg"
    #reg import $Reg 
    
    
}


Optimize-Bloat
