function Flatten ( $Array ) {
        
    return $Array | ForEach-Object {
        $_
    }

}
function ConvertTo-StringData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, Position = 0, ValueFromPipeline)]
        [HashTable[]]$HashTable
    )
    process {
        foreach ($item in $HashTable) {
            foreach ($entry in $item.GetEnumerator()) {
                "{0}={1}" -f $entry.Key, $entry.Value
            }
        }
    }
}
function Start-Background( $Scriptblock , $Parameters) {

    $newPowerShell = [PowerShell]::Create().AddScript($Scriptblock).AddParameters($Parameters)

    
    
    $representation = ConvertTo-StringData $Parameters
    Write-Information "Starting a background script: $Scriptblock with arguments $representation"
        
    $Handler = $newPowerShell.BeginInvoke()    
    
    return @{ 
        PowerShell = $newPowerShell ; 
        Handle = $Handler 
    }
    
}
function Wait-Background( $Jobs ) {
    $Jobs = Flatten $Jobs
    $sw = [Diagnostics.Stopwatch]::StartNew()

    $Jobs | ForEach-Object {
            $_.Powershell.EndInvoke($_.handle)
            $_.PowerShell.Dispose()
        }

    $sw.Stop()
    $T  = $sw.elapsed
    $N = $Jobs.Count
    Write-Information "$N Jobs completed after waiting $T"
    
}
