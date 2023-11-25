# set PowerShell to UTF-8
[console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
$PSDefaultParameterValues = @{ '*:Encoding' = 'utf8' }


$CurrentDir = Get-Location
if ($CurrentDir.Path -eq "C:\Windows\System32") {
    $Desktop = "C:\Users\Mateus\Desktop"
    Set-Location $Desktop
}

$Aliases = Join-Path $PSScriptRoot "/lib/powershell-aliases.ps1"
. $Aliases

$Completion = Join-Path $PSScriptRoot "/lib/powershell-completion.ps1"
. $Completion

$Terminal = Join-Path $PSScriptRoot "/lib/powershell-terminal.ps1"
. $Terminal

# Todo: Read this.
# https://docs.microsoft.com/en-us/powershell/module/psreadline/about/about_psreadline?view=powershell-7.2

function OptimizePowershell() {
    $env:PATH = [Runtime.InteropServices.RuntimeEnvironment]::GetRuntimeDirectory()
    [AppDomain]::CurrentDomain.GetAssemblies() | ForEach-Object {
        $path = $_.Location
        if ($path) { 
            $name = Split-Path $path -Leaf
            Write-Host -ForegroundColor Yellow "`r`nRunning ngen.exe on '$name'"
            ngen.exe install $path /nologo
        }
    }
}