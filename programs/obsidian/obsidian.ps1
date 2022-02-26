function installPlugin
{

    param([String] $PluginURL,
        [String] $ObsidianRoot
    )

    $CurrentDirectory = Resolve-Path $PSScriptRoot
    $TempFile = Join-Path $CurrentDirectory "plugin.zip"
    Invoke-RestMethod -Uri $PluginURL -OutFile $TempFile

    $ObsidianPluginPath = Join-Path $ObsidianRoot "/.obsidian/plugins"

    Expand-Archive $TempFile $ObsidianPluginPath -Force
    Remove-Item $TempFile -Force

}


$ObsidianRoot = "C:\Users\Mateus\OneDrive\vault\Canelhas"
$PluginGit = "https://github.com/denolehov/obsidian-git/releases/download/1.21.1/obsidian-git-1.21.1.zip"
$PluginExplorer = "https://github.com/pjeby/quick-explorer/releases/download/0.1.10/quick-explorer.zip"

Write-Host "Starting the Installation of plugins."
installPlugin $PluginGit $ObsidianRoot
installPlugin $PluginExplorer $ObsidianRoot
Write-Host "Ended the Installation of plugins."
