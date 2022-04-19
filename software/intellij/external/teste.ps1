param( 
    $ModuleSdkPath,
    $FilePath
)



echo $ModuleSdkPath
echo $FilePath


# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
# Create a new form
$Form1 = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$Form1.ClientSize = '300,250'
$Form1.text = "PowerShell GUI Example"
$Form1.BackColor = "#ffffff"

# Display the form
[void]$Form1.ShowDialog()


# git add .
# git commit -m $CommitMessage

