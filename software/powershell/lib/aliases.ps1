function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function Git-Ammend {
    git commit --amend --no-edit
}

Set-Alias -Name vim -Value nvim
Set-Alias -Name grep -Value findstr
Set-Alias -Name tig -Value 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias -Name less -Value 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias -Name gammend -Value Git-Ammend
Set-Alias -Name sublime -Value "C:\Program Files\Sublime Text\sublime_text.exe"




