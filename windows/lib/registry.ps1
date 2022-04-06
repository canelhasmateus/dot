function Search-Registry { 
    <# 
.SYNOPSIS 
Searches registry key names, value names, and value data (limited). 

.DESCRIPTION 
This function can search registry key names, value names, and value data (in a limited fashion). It outputs custom objects that contain the key and the first match type (KeyName, ValueName, or ValueData). 

.EXAMPLE 
Search-Registry -Path HKLM:\SYSTEM\CurrentControlSet\Services\* -SearchRegex "svchost" -ValueData 

.EXAMPLE 
Search-Registry -Path HKLM:\SOFTWARE\Microsoft -Recurse -ValueNameRegex "ValueName1|ValueName2" -ValueDataRegex "ValueData" -KeyNameRegex "KeyNameToFind1|KeyNameToFind2" 

#> 
    [CmdletBinding()] 
    param( 
        [Parameter(Mandatory, Position = 0, ValueFromPipelineByPropertyName)] 
        [Alias("PsPath")] 
        # Registry path to search 
        [string[]] $Path, 
        # Specifies whether or not all subkeys should also be searched 
        [switch] $Recurse, 
        [Parameter(ParameterSetName = "SingleSearchString", Mandatory)] 
        # A regular expression that will be checked against key names, value names, and value data (depending on the specified switches) 
        [string] $SearchRegex, 
        [Parameter(ParameterSetName = "SingleSearchString")] 
        # When the -SearchRegex parameter is used, this switch means that key names will be tested (if none of the three switches are used, keys will be tested) 
        [switch] $KeyName, 
        [Parameter(ParameterSetName = "SingleSearchString")] 
        # When the -SearchRegex parameter is used, this switch means that the value names will be tested (if none of the three switches are used, value names will be tested) 
        [switch] $ValueName, 
        [Parameter(ParameterSetName = "SingleSearchString")] 
        # When the -SearchRegex parameter is used, this switch means that the value data will be tested (if none of the three switches are used, value data will be tested) 
        [switch] $ValueData, 
        [Parameter(ParameterSetName = "MultipleSearchStrings")] 
        # Specifies a regex that will be checked against key names only 
        [string] $KeyNameRegex, 
        [Parameter(ParameterSetName = "MultipleSearchStrings")] 
        # Specifies a regex that will be checked against value names only 
        [string] $ValueNameRegex, 
        [Parameter(ParameterSetName = "MultipleSearchStrings")] 
        # Specifies a regex that will be checked against value data only 
        [string] $ValueDataRegex 
    ) 

    begin { 
        switch ($PSCmdlet.ParameterSetName) { 
            SingleSearchString { 
                $NoSwitchesSpecified = -not ($PSBoundParameters.ContainsKey("KeyName") -or $PSBoundParameters.ContainsKey("ValueName") -or $PSBoundParameters.ContainsKey("ValueData")) 
                if ($KeyName -or $NoSwitchesSpecified) { $KeyNameRegex = $SearchRegex } 
                if ($ValueName -or $NoSwitchesSpecified) { $ValueNameRegex = $SearchRegex } 
                if ($ValueData -or $NoSwitchesSpecified) { $ValueDataRegex = $SearchRegex } 
            } 
            MultipleSearchStrings { 
                # No extra work needed 
            } 
        } 
    } 

    process { 
        if ($ValueDataRegex ) {
            $ValueDataRegex = [Regex]::new( $ValueDataRegex )
        }
        if ($ValueNameRegex ) {
            $ValueNameRegex = [Regex]::new( $ValueNameRegex )
        }
        if ($KeyNameRegex ) {
            $KeyNameRegex = [Regex]::new( $KeyNameRegex )
        }
        
        
        foreach ($CurrentPath in $Path) { 
            Get-ChildItem $CurrentPath -Recurse:$Recurse -ErrorAction SilentlyContinue | ForEach-Object { 
                $Key = $_ 
                

                if ($Key.PSChildName -match $KeyNameRegex) {  
                    return [PSCustomObject] @{ 
                        Key    = $Key 
                        Reason = "KeyName" 
                    } 
                }  

                if ($Key.GetValueNames() -match $ValueNameRegex) {  
                    
                    return [PSCustomObject] @{ 
                        Key    = $Key 
                        Reason = "ValueName" 
                    } 
                }  

                $Values = $Key.GetValueNames() | ForEach-Object { $Key.GetValue($_) }
                if ( $Values -match $ValueDataRegex) {  
                    
                    return [PSCustomObject] @{ 
                        Key    = $Key 
                        Reason = "ValueData" 
                    } 
                } 
            } 
        } 
    } 
} 

function Takeown-Registry($key) {
    # TODO does not work for all root keys yet
    switch ($key.split('\')[0]) {
        "HKEY_CLASSES_ROOT" {
            $reg = [Microsoft.Win32.Registry]::ClassesRoot
            $key = $key.substring(18)
        }
        "HKEY_CURRENT_USER" {
            $reg = [Microsoft.Win32.Registry]::CurrentUser
            $key = $key.substring(18)
        }
        "HKEY_LOCAL_MACHINE" {
            $reg = [Microsoft.Win32.Registry]::LocalMachine
            $key = $key.substring(19)
        }
    }

    # get administraor group
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])

    # set owner
    $key = $reg.OpenSubKey($key, "ReadWriteSubTree", "TakeOwnership")
    $acl = $key.GetAccessControl()
    $acl.SetOwner($admins)
    $key.SetAccessControl($acl)

    # set FullControl
    $acl = $key.GetAccessControl()
    $rule = New-Object System.Security.AccessControl.RegistryAccessRule($admins, "FullControl", "Allow")
    $acl.SetAccessRule($rule)
    $key.SetAccessControl($acl)
}

function Takeown-File($path) {
    takeown.exe /A /F $path
    $acl = Get-Acl $path

    # get administraor group
    $admins = New-Object System.Security.Principal.SecurityIdentifier("S-1-5-32-544")
    $admins = $admins.Translate([System.Security.Principal.NTAccount])

    # add NT Authority\SYSTEM
    $rule = New-Object System.Security.AccessControl.FileSystemAccessRule($admins, "FullControl", "None", "None", "Allow")
    $acl.AddAccessRule($rule)

    Set-Acl -Path $path -AclObject $acl
}

function Takeown-Folder($path) {
    Takeown-File $path
    foreach ($item in Get-ChildItem $path) {
        if (Test-Path $item -PathType Container) {
            Takeown-Folder $item.FullName
        }
        else {
            Takeown-File $item.FullName
        }
    }
}

function Elevate-Privileges {
    param($Privilege)
    $Definition = @"
    using System;
    using System.Runtime.InteropServices;
    public class AdjPriv {
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool AdjustTokenPrivileges(IntPtr htok, bool disall, ref TokPriv1Luid newst, int len, IntPtr prev, IntPtr rele);
        [DllImport("advapi32.dll", ExactSpelling = true, SetLastError = true)]
            internal static extern bool OpenProcessToken(IntPtr h, int acc, ref IntPtr phtok);
        [DllImport("advapi32.dll", SetLastError = true)]
            internal static extern bool LookupPrivilegeValue(string host, string name, ref long pluid);
        [StructLayout(LayoutKind.Sequential, Pack = 1)]
            internal struct TokPriv1Luid {
                public int Count;
                public long Luid;
                public int Attr;
            }
        internal const int SE_PRIVILEGE_ENABLED = 0x00000002;
        internal const int TOKEN_QUERY = 0x00000008;
        internal const int TOKEN_ADJUST_PRIVILEGES = 0x00000020;
        public static bool EnablePrivilege(long processHandle, string privilege) {
            bool retVal;
            TokPriv1Luid tp;
            IntPtr hproc = new IntPtr(processHandle);
            IntPtr htok = IntPtr.Zero;
            retVal = OpenProcessToken(hproc, TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY, ref htok);
            tp.Count = 1;
            tp.Luid = 0;
            tp.Attr = SE_PRIVILEGE_ENABLED;
            retVal = LookupPrivilegeValue(null, privilege, ref tp.Luid);
            retVal = AdjustTokenPrivileges(htok, false, ref tp, 0, IntPtr.Zero, IntPtr.Zero);
            return retVal;
        }
    }
"@
    $ProcessHandle = (Get-Process -id $pid).Handle
    $type = Add-Type $definition -PassThru
    $type[0]::EnablePrivilege($processHandle, $Privilege)
}


function GetKind($ValueKind ) {
    
    try {
        $Kind = $ValueKind.ToLower()
    }
    catch {
        $Kind = "dword"
    }

    
    $Result = switch ($Kind) {
        "binary" { 3 }
        "dword" { 4 }
        "expandstring" { 2 }
        "multistring" { 7 }
        "none" { -1 }
        "qword" { 11 }
        "string" { 1 }
        "unknown" { 0 }
        default { 4 }
    }
    
    return $Result


}
function Set-Registry( $Path , $Key , $Value , $Kind ) {
    
    # $Total = Join-Path $Path $Key
    # Takeown-Registry $Total

    $PreviousValue = [microsoft.win32.registry]::GetValue( $Path, $Key , $null)
    
    $Kind = GetKind  $Kind
    [microsoft.win32.registry]::SetValue( $Path , $Key, $Value, $Kind)
    
    Start-Sleep -Milliseconds 200
    $CurrentValue = [microsoft.win32.registry]::GetValue( $Path, $Key , $null)

    return [PSCustomObject]@{ 
        Success       = $CurrentValue -eq $Value
        Key           = $Key
        PreviousValue = $PreviousValue 
        DesiredValue  = $Value
        CurrentValue  = $CurrentValue
        Path          = $Path
    } 
    
}

function Add-Registry( $List ) {
    Elevate-Privileges
    $List | ForEach-Object {
        $Table = $_
        Set-Registry @Table

    } | Format-Table -AutoSize -Wrap
}



