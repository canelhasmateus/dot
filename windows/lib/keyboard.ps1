# Capture the existing list
function Set-KeyboardLayouts {

    $someVar = Get-WinUserLanguageList
    $someVar[0].Spellchecking = $false    
    $someVar[0].InputMethodTips.Add('0409:00010416')
    $someVar[0].InputMethodTips.Remove('0409:00000409')
    Set-WinUserLanguageList $someVar -Force

    $someVar = Get-WinUserLanguageList
    $someVar[0].InputMethodTips.Add('0409:a0000409')
    Set-WinUserLanguageList $someVar -Force
    

}

function Install-Colemak( $Path ) {

    
    $ParentDir = Split-Path $Path -Parent
    $Dest = Join-Path $ParentDir "/TmpColemak"
    Expand-Archive -Path $Path -DestinationPath $Dest -Force

    Get-ChildItem -Path $Dest -Include '*amd*.msi'  -Recurse | ForEach-Object {
        $Name = $_.Name
        
        Write-Information "Installing $Name"
        Start-Process $_.FullName -ArgumentList "/quiet /passive /qn /norestart"
        
    }
    Remove-Item -Path $Dest -Recurse
}





# Get-WinUserLanguageList


# [microsoft.win32.registry]::SetValue(
#     "HKEY_CURRENT_USER\.DEFAULT\Keyboard Layout\Preload\Name", 
#     "1", "00010416")

# Get-ChildItem -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Keyboard Layouts\'    

# Set-WinDefaultInputMethodOverride -InputTip '0409:00010416'
# 0409:00000409





