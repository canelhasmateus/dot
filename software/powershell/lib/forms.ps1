# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms
# Create a new form
$Form1 = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$Form1.ClientSize = '300,250'
$Form1.text = "PowerShell GUI Example"
$Form1.BackColor = "#ffffff"
$List = New-Object system.Windows.Forms.ComboBox
$List.text = ""
$List.width = 170
$List.autosize = $true
# Add the items in the dropdown list
@('Jack', 'Dave', 'Alex') | ForEach-Object { [void] $List.Items.Add($_) }
# Select the default value
$List.SelectedIndex = 0
$List.location = New-Object System.Drawing.Point(70, 100)
$List.Font = 'Microsoft Sans Serif,10'

#Add a label
$Description = New-Object system.Windows.Forms.Label
$Description.text = "Selected index: $selected"
$Description.AutoSize = $false
$Description.width = 450
$Description.height = 50
$Description.location = New-Object System.Drawing.Point(20, 50)
$Description.Font = 'Microsoft Sans Serif,10'

#Catch changes to the list

$List.add_SelectedIndexChanged({
        $selected = $List.SelectedIndex
        write-host $selected
        $Description.text = "Selected index: $selected"

    })

$Form1.Controls.Add($List)
$Form1.Controls.Add($Description)

# Display the form
[void]$Form1.ShowDialog()
