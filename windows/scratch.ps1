
$LinksModule = Join-Path $PSScriptRoot "/lib/linking.ps1"
.$LinksModule


    
$Root = Split-Path $PSScriptRoot -Parent
    
$MappingFile = "/windows/blob/mapping.json"
Set-Mappings $Root $MappingFile
        