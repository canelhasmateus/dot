function FindCommand ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function GitAmmend {
    git add .
    git commit --amend --no-edit
    git push --force-with-lease
}

function GitShove($Message) {
    if ( -not $Message ) {
        $Message  = Read-Host "Message for the commit/push"
    }
    git add "."
    git commit -m $Message
    git push --force-with-lease
}

function GitShoveWorkspace( $Message ) {
    Write-Host "Shoving All"
    $OriginalPath = Get-Location    
    Write-Host "$OriginalPath"
    $Workspaces = Get-ChildItem -Path $OriginalPath -Filter "*.code-workspace" 
    
    if ( -not $Workspaces){
        Write-Host "Unable to find a workspace file."
        return
    }
    
    if (-not $Message) {
        $Message = Read-Host "Message for the commit/push"
    }

    foreach ($currentWorkspace in $Workspaces) {
        $Config = Get-Content $currentWorkspace | ConvertFrom-Json
        foreach ($currentFolder in $Config.folders) {
            
            $ResolvedFolder = Resolve-Path $currentFolder.path
            Write-Host "Saving " $ResolvedFolder
            
            Set-Location  $ResolvedFolder
            GitShove "." $Message
            Set-Location $OriginalPath
        }


    }
    

}

Set-Alias -Name vim -Value nvim
Set-Alias -Name grep -Value findstr
Set-Alias -Name tig -Value 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias -Name less -Value 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias -Name sublime -Value "C:\Program Files\Sublime Text\sublime_text.exe"


Set-Alias -Name gammend -Value GitAmmend
Set-Alias -Name gshove -Value GitShove
Set-Alias -Name gshoveall -Value GitShoveWorkspace
Set-Alias -Name which -Value FindCommand


