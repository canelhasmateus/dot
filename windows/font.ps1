$CurrentDir = Resolve-Path "$PSScriptRoot"
$OutFile = Join-Path $CurrentDir "./mono.zip"
$FontURI = "https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/JetBrainsMono.zip"

Invoke-RestMethod -Uri   $FontURI -OutFile $OutFile
Expand-Archive $OutFile -DestinationPath $CurrentDir

$Source = Join-Path $CurrentDir "*"
$Destination = (New-Object -ComObject Shell.Application).Namespace(0x14)
$TempFolder = "C:\Windows\Temp\Fonts"

# Create the temp directory if it doesn't already exist
New-Item $TempFolder -Type Directory -Force | Out-Null

Get-ChildItem -Path $Source -Include '*.ttf', '*.ttc', '*.otf' -Recurse | ForEach {

    If (-not(Test-Path "C:\Windows\Fonts\$( $_.Name )"))
    {

        $Font = "$TempFolder\$( $_.Name )"

        # Copy font to local temporary folder
        Copy-Item $( $_.FullName ) -Destination $TempFolder

        # Install font
        $Destinatiozn.CopyHere($Font, 0x10)

        # Delete temporary copy of font
        Remove-Item $Font -Force
    }

    Remove-Item $_ -Force

}

Remove-Item $OutFile -Force
