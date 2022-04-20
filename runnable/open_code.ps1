param( 
    $ProjectDir, $FilePath, 
    $LineNumber, $ColumnNumber 
)

$Destination = "${FilePath}:${LineNumber}:${ColumnNumber}"
code --new-window --goto $Destination
code --add $ProjectDir
