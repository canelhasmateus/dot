param( 
    $FilePath
)


$Codes = @( "Failure" , "Success")
$StageNames = @( "Red" , "Green" , "Refactor")


function flatten( $a ) {
    return $a | ForEach-Object { 
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

# Test Running

function CheckRed( $currentState , $success ) {
    
    $Gotten = $Codes[$Success]
    return @{ 
        Expected = $Codes[0]
        Gotten   = $Gotten
        Success  = $Codes[0] -eq $Gotten
    }

}

function CheckGreen( $currentState , $success) {

    
    return @{ 
        Success  = $Codes[1] -eq $Codes[$success]
        Expected = $Codes[1]
        Gotten   = $Codes[$Success]
    }


    
}

function CheckRefactor( $currentState , $success) {
    
    return @{ 
        Success  = $Codes[1] -eq $Codes[$success]
        Expected = $Codes[1]
        Gotten   = $Codes[$Success]
    }

}

function PassesTests( $File ) {

    
    if ($FilePath -match ".+\.py") {
        python $FilePath
    }

    elseif ($FilePath -match ".+\.java") {
        java $FilePath
    }
    else {
        throw "Dont know how to handle file "
    }
    
    

    if ( $LastExitCode -eq 0 ) { 
        return 1
    }
    return 0
    

}

function RunTest( $currentState ) {
    
    $stages = @( 
    "CheckRed"
    "CheckGreen"
    "CheckRefactor"
    )

    $Success = PassesTests $FilePath 
    $CurrentIndex = $currentState["currentIndex"]
    
    $Checker = $stages[ $CurrentIndex ]
    
    $Status = Invoke-Expression "$Checker $CurrentState $Success"
    
    $status["currentIndex"] = $CurrentIndex
    if ($Status["Success"] -eq $true) {
        $Status["nextIndex"] = ($CurrentIndex + 1 ) % 3 
    }
    else {
        $Status["nextIndex"] = $CurrentIndex
    }
    
    
    
    return $Status
}

# IO
$appdata = [System.Environment]::GetFolderPath("LocalApplicationData")  
$stateFile = Join-Path $appdata "/tdd/history.json"

function SaveState( $globalState , $newState  ) {
    
    # New-Item $stateFile -Force -ItemType File *> $null
    $LastRuns = $globalState[$FilePath] 
    
    if  ( $LastRuns ) {
        # ConvertTo-StringData $LastRuns
        $LastRuns = @( $LastRuns , $newState )
    }
    else { 
        $LastRuns = @( $newState )
    }
    
    
    $globalState[$FilePath] = Flatten $LastRuns
    $Content = $globalState |  ConvertTo-Json 
    Set-Content $stateFile $Content

}


function GetCurrentState( $Contents ) {
    
    $CurrentRun = @{
        currentIndex = 0
        nextIndex = 0
    }
    
    $LastRuns = $Contents[ $FilePath ]
    
    
    if ( $LastRuns) {
        
        
        $LastRun = $LastRuns[ $LastRuns.Count - 1]

        
        Write-Host (ConvertTo-StringData $LastRun)            
        $CurrentRun["currentIndex"] = $LastRun["nextIndex"]    
        $CurrentRun["nextIndex"] = $CurrentRun["currentIndex"]
    }
    
    return $CurrentRun
    
}

function GetGlobalState {
    
    $Content = Get-Content  $stateFile  -ErrorAction Ignore
    
    
    $A = $Content | ConvertFrom-Json -AsHashtable
    if (-not $A){
        $A = New-Object System.Collections.Hashtable
    }
    
    return $A
    
}

function Display( $obj ) {
    $obj["currentStage"] = $StageNames[ $obj.currentIndex ] 
            
    @( $obj ) | ForEach-Object {
        return [PSCustomObject]$_
    } | Format-Table 
    
}

function DoIt {

    $globalState = GetGlobalState
    $currentState = GetCurrentState  $globalState 
    $newState = RunTest $currentState

    
    
    SaveState $globalState $newState
    Display $newState

    if ( $newState["Success"]) {
        exit 0
    }
    else {
        exit 1 
    }

}

DoIt
