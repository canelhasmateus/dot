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
    $status["id"] = $currentState["id"]
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
    
    if ( $LastRuns ) {
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

function GetLastRun( $globalState ) {

    $LastRuns = $globalState[ $FilePath ]
    if ($LastRuns ) {
        return $LastRuns[ $LastRuns.Count - 1]
    }
    
    return $null

}
function CreateCurrentState( $globalState ) {
    
    $CurrentRun = @{
        id           = 0
        currentIndex = 0
        nextIndex    = 0
    }
    
    $LastRun = GetLastRun $globalState
    if ( $LastRun ) {
    
        $CurrentRun["id"] = $LastRun["id"] + 1 
        $CurrentRun["currentIndex"] = $LastRun["nextIndex"]    
        $CurrentRun["nextIndex"] = $CurrentRun["currentIndex"]
        
    }
    
    return $CurrentRun
    
}

function GetGlobalState {
    
    $Content = Get-Content  $stateFile  -ErrorAction Ignore
    
    
    $A = $Content | ConvertFrom-Json -AsHashtable
    if (-not $A) {
        $A = New-Object System.Collections.Hashtable
    }
    
    

    return $A
    
}


function colorize( $color , $content) {
    $ColorSequence = "`e[38;2;${color}m"
    return $ColorSequence + $content

}

function conditional( $cond , $ifTrue , $ifFalse ) {
    if ( $cond ) {
        return $ifTrue
    }
    return $ifFalse
}
function Display( $globalState ) {
    
    $obj = GetLastRun $globalState
    $obj["currentStage"] = $StageNames[ $obj["currentIndex"] ] 
            
    $color = conditional $obj["Success"] "0;255;0"  "255;0;0" 


    @( $obj ) | ForEach-Object {
        return [PSCustomObject]$_
    } 
    | Format-Table -Auto @( 
        @{ Label = "Id"; Expression = { colorize $color $_.id } }
        @{ Label = "Stage" ; Expression = { colorize $color $_.currentStage } }
        @{ Label = "Expected" ; Expression = {  colorize $color $_.Expected } } 
        @{ Label = "Gotten" ; Expression = {  colorize $color $_.Gotten } } 
    )
    
    
    
}

function DoIt {

    $globalState = GetGlobalState
    $currentState = CreateCurrentState  $globalState 
    $newState = RunTest $currentState

    
    
    SaveState $globalState $newState


    if ( $newState["Success"]) {
        git add . 2>&1 3>&1 > $null
        $currentStageName = $StageNames[ $newState["currentIndex"] ] 
        git commit -m "auto: Tdd $currentStageName" 2>&1 3>&1 > $null
        $code = 0
    }
    else {
        $code = 1
    }
    

    Display $globalState
    exit $code
}

DoIt
