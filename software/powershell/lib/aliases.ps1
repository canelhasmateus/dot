function FindCommand ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function GitAmmend {
    git add .
    git commit --amend --no-edit
    git push --force-with-lease
}

function GitShove {
    git add .
    $Message  = Read-Host "Message for the commit/push"
    git commit -m $Message
    git push --force-with-lease
}

Set-Alias -Name vim -Value nvim
Set-Alias -Name grep -Value findstr
Set-Alias -Name tig -Value 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias -Name less -Value 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias -Name sublime -Value "C:\Program Files\Sublime Text\sublime_text.exe"


Set-Alias -Name gammend -Value GitAmmend
Set-Alias -Name gshove -Value GitShove
Set-Alias -Name which -Value FindCommand
