https://docs.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption?view=powershell-7.2#:~:text=Description%20The%20Set-PSReadLineOption%20cmdlet%20customizes%20the%20behavior%20of,line.%20To%20view%20the%20PSReadLine%20settings%2C%20use%20Get-PSReadLineOption.

https://github.com/dracula/powershell/blob/master/INSTALL.md'

https://www.youtube.com/watch?v=5-aK2_WwrmM&list=WL&index=68&t=44s
https://techcommunity.microsoft.com/t5/itops-talk-blog/autocomplete-in-powershell/ba-p/2604524
https://www.addictivetips.com/windows-tips/fix-the-font-not-changing-in-powershell-on-windows-10/#:~:text=You%20can%20change%20the%20font,a%20font%20and%20its%20size.


https://docs.microsoft.com/en-us/powershell/module/psreadline/set-psreadlinekeyhandler?view=powershell-7.2#:~:text=Description%20The%20Set-PSReadLineKeyHandler%20cmdlet%20customizes%20the%20result%20when,that%20is%20possible%20from%20within%20a%20PowerShell%20script.

https://www.damirscorner.com/blog/posts/20211119-PowerShellModulesForABetterCommandLine.html


```powershell

Import-Module posh-git
Import-Module oh-my-posh

$omp_config = Join-Path $PSScriptRoot ".\takuya.omp.json"

oh-my-posh --init --shell pwsh --config $omp_config | Invoke-Expression


```

