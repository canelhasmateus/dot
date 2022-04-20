$Aliases = Join-Path $PSScriptRoot "/lib/aliases"
. $Aliases

$Feel = Join-Path $PSScriptRoot "/lib/feel"
. $Feel

# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding



# $env:GIT_SSH = "C:\Windows\system32\OpenSSH\ssh.exe"
