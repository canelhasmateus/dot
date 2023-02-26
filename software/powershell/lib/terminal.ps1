$theme = Join-Path $PSScriptRoot "theme.omp.json"
oh-my-posh init pwsh --config $theme | Invoke-Expression

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+d'
Set-PsFzfOption -PSReadlineChordReverseHistory 'Ctrl+r'
Set-PsFzfOption -TabExpansion
 
$currentVersion = $PsversionTable.PSVersion.Major
if ($currentVersion -gt 5) {
    Import-Module Z
}
