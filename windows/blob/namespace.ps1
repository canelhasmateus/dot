$code = { 
    . "C:\Users\Mateus\OneDrive\dot\windows\lib\fonts.ps1"
    Download-NerdFonts
}

$newPowerShell = [PowerShell]::Create().AddScript($code)
$job = $newPowerShell.BeginInvoke()
While (-Not $job.IsCompleted) {}
$completed = Get-Date

$result = $newPowerShell.EndInvoke($job)
$received = Get-Date

$newPowerShell.Dispose()
$cleanup = Get-Date

$spinup = $result[0]
$exit = $result[1]

$timeToLaunch = ($spinup - $start).TotalMilliseconds
$timeToExit = ($completed - $exit).TotalMilliseconds
$timeToRunCommand = ($exit - $spinup).TotalMilliseconds
$timeToReceive = ($received - $completed).TotalMilliseconds
$timeToCleanup = ($cleanup - $received).TotalMilliseconds

'{0,-30} : {1,10:#,##0.00} ms' -f 'Time to set up background job', $timeToLaunch
'{0,-30} : {1,10:#,##0.00} ms' -f 'Time to run code', $timeToRunCommand
'{0,-30} : {1,10:#,##0.00} ms' -f 'Time to exit background job', $timeToExit
'{0,-30} : {1,10:#,##0.00} ms' -f 'Time to receive results', $timeToReceive
'{0,-30} : {1,10:#,##0.00} ms' -f 'Time to cleanup runspace', $timeToCleanup

