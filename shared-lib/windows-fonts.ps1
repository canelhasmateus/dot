# Fonts

function Uninstall-Fonts($Fonts ) {
    # For some reason, it would seem that fonts installed in  manners 
    # other than the Install-Fonts procedure fail to be removed by this one. 
    $Number = $Fonts.Count
    
    Write-Information "Uninstalling  $Number Fonts"
    $WindowsFonts = "C:\Windows\Fonts\"
    $RegistryFonts = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    foreach ($Font in $Fonts) {
        $FontPath = Join-Path $WindowsFonts $Font
        Remove-Item $FontPath -ErrorAction Ignore
        Remove-ItemProperty -Name $Font.BaseName -Path $RegistryFonts -ErrorAction Ignore
    }


}

function Install-Fonts( $Fonts ) {
    
    $Number = $Fonts.Count
    Write-Information "Installing  $Number Fonts"
    $WindowsFonts = "C:\Windows\Fonts\"
    $RegistryFonts = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
    foreach ($Font in $Fonts) { 
        
        Copy-Item $Font $WindowsFonts -Force -ErrorAction Ignore
        New-ItemProperty -Name $Font.BaseName -Path $RegistryFonts -PropertyType string -Value $Font.name  -ErrorAction Ignore

     
    }

}

function New-FontArchive($Url , $ZipPath ) {
    
    Write-Information "Downloading Font archive at $Url to $ZipPath"
    

    If ( Test-Path $ZipPath ) {
        Write-Information "$ZipPath Already exists and won't be Downloaded Again"
    }
    else {
        Invoke-RestMethod -Uri   $FontURI -OutFile $ZipPath
    }

    return $ZipPath
    

}
function Use-FontArchive($Archive) {
    
    $Parent = Split-Path $Archive -Parent
    
    Expand-Archive $Archive -DestinationPath $Parent -Force
    
    
    $Fonts = Get-ChildItem -Path $Parent -Include '*.ttf', '*.ttc', '*.otf' -Recurse 
    Install-Fonts $Fonts
    
    Remove-Item $Fonts -Force    
    Remove-Item $Archive -Force

}




function Add-NerdFonts {

    $DownloadTo = [Environment]::GetFolderPath("Desktop") 
    $FontURI = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"    
    $Archive = Join-Path $DownloadTo "jet_brains_mono.zip"
    New-FontArchive $FontURI $Archive
    Use-FontArchive $Archive
    
    
    
     
}

