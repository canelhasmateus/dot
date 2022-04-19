function Git-Ammend {
    git commit --amend --no-edit
}


New-Alias -Name gammend -Value Git-Ammend