# ORIGINAL
<#
# Main GUI Window
Add-Type -Assembly System.Windows.Forms
$Main_Window = New-Object System.Windows.Forms.Form    # '$Main_Window' is the variable used for the main window object
$Main_Window.Text = "Windows Toast Generator"          # Window Title
$Main_Window.Width = 800                               # Window Width
$Main_Window.Height = 500                              # Window Height
$Main_Window.AutoSize = $true                          # Auto-sizes the window to fit all elements of the form object
# The above lines define specific properties of the GUI window (Title, Height, Width, Auto-Size enabled)

# Label for Selecting which Service (or 'Buttons') in the Main GUI Window
$Label = New-Object System.Windows.Forms.Label
$Label.Text = "Services"
$Label.Location = New-Object System.Drawing.Point(0,10)
$Label.AutoSize = $true
$Main_Window.Controls.Add($Label)
$ComboBox = New-Object System.Windows.Forms.ComboBox
$ComboBox.Width= 300
$Selections = Get-Service *
Foreach ($Selection in $Selections)
    {
        $ComboBox.Items.Add($Selection.Name)
    }
$ComboBox.Location = New-Object System.Drawing.Point(60,10)
$Main_Window.Controls.Add($ComboBox)

$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Service Status"
$Label2.Location = New-Object System.Drawing.Point(0,40)
$Label2.AutoSize = $true
$Main_Window.Controls.Add($Label2)

$Label3 = New-Object System.Windows.Forms.Label
$Label3.Text=""
$Label3.Location = New-Object System.Drawing.Point(110,40)
$Label3.AutoSize = $True
$Main_Window.Controls.Add($Label3)

$Button= New-Object System.Windows.Forms.Button
$Button.Location = New-Object System.Drawing.Size(400,10)
$Button.Size = New-Object System.Drawing.Size(120,23)
$Button.Text = "Check"
$Main_Window.Controls.Add($Button)

$Button.Add_Click(
{
$Label3.Text = (Get-Service).Status
}
)


$Main_Window.ShowDialog()  # Causes the "form object" to become visible (halts the active Powershell terminal until the GUI is closed)
#>

<#
Clear-Host
Write-Host -ForegroundColor Yellow "===========`nTOASTINATOR`n==========="
Write-Host -ForegroundColor Green "
1. Informational (Info)
2. Warning (Warn)
3. Generic (General)
----------------
"

$TypeChoice = (Read-Host -Prompt "Type a number corresponding to the type of notice you want to create")
while($true){
if ($TypeChoice -like "1*" -or $TypeChoice -like "info*") {Set-Variable -Name "image" -Value .\images\info-icon.png; break}
elseif ($TypeChoice -like "2*" -or $TypeChoice -like "warn*") {Set-Variable -Name "image" -Value .\images\warning_triangle-icon.png; break}
elseif ($TypeChoice -like "3*" -or $TypeChoice -like "general*") {Set-Variable -Name "image" -Value .\images\info-icon.png; break}
else {Write-Host -ForegroundColor Red "ERROR In Selection";continue}
}

$Title = Read-Host -Prompt "Enter toast notification title"
$Body = Read-Host -Prompt "Enter toast notification body"

# Load Assemblies
[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
[Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

# Build XML Template
[xml]$ToastTemplate = @"
<toast>
    <visual>
        <binding template="ToastImageAndText03">
            <text id="1">$Title</text>
            <text id="2">$Body</text>
            <image id="1" src='info-icon'/>
        </binding>
    </visual>
</toast>
"@

#Prepare XML
$ToastXml = [Windows.Data.Xml.Dom.XmlDocument]::New()
$ToastXml.LoadXml($ToastTemplate.OuterXml)
 
#Prepare and Create Toast
$ToastMessage = [Windows.UI.Notifications.ToastNotification]::New($ToastXML)
[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier("System Notification").Show($ToastMessage)

# Clears previously-set variables

#$Title = $null
#$Body = $null
#$Image = $null
#>
$toast_Folder = ".\toast"
if 
(
    (Test-Path $toast_Folder) -eq $false
)
{
    New-Item -ItemType Directory $toast_Folder | Out-Null
    Write-Host -ForegroundColor green "Created 'scripts' folder in drive root"
    Set-Location $toast_Folder
    Copy-Item .\images $toast_Folder
    Write-Host -ForegroundColor green "Set working location to $((Get-Location).Path), and moving 'images' folder"
}
else
{
    Set-Location C:\scripts
    Move-Item .\images C:\scripts
}
Clear-Host

$shell = New-Object -ComObject Wscript.shell
Write-Host -ForegroundColor Green
'
/$$$$$$$$                              /$$     /$$                       /$$                        
|__  $$__/                             | $$    |__/                      | $$                        
  | $$  /$$$$$$   /$$$$$$   /$$$$$$$ /$$$$$$   /$$ /$$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$   /$$$$$$ 
  | $$ /$$__  $$ |____  $$ /$$_____/|_  $$_/  | $$| $$__  $$ |____  $$|_  $$_/   /$$__  $$ /$$__  $$
  | $$| $$  \ $$  /$$$$$$$|  $$$$$$   | $$    | $$| $$  \ $$  /$$$$$$$  | $$    | $$  \ $$| $$  \__/
  | $$| $$  | $$ /$$__  $$ \____  $$  | $$ /$$| $$| $$  | $$ /$$__  $$  | $$ /$$| $$  | $$| $$      
  | $$|  $$$$$$/|  $$$$$$$ /$$$$$$$/  |  $$$$/| $$| $$  | $$|  $$$$$$$  |  $$$$/|  $$$$$$/| $$      
  |__/ \______/  \_______/|_______/    \___/  |__/|__/  |__/ \_______/   \___/   \______/ |__/      
                                                                                                                                                                                            
'

While ($true)
{

    if
    (
        (
            $Toast_Title = 
            (
                Read-Host -Prompt "Enter the message title"
            )
        ) -like ""
    )
    {
        Write-Host -ForegroundColor Red "Value cannot be blank!"
        continue
    }
    if
    (
        (
            $Toast_Body = (Read-Host -Prompt "Enter the message body")
        ) -like ""
    )
    {
        Write-Host -ForegroundColor Red "Value cannot be blank!"
        continue
    }
while ($true)
{
    $Completed_File = ".\$(Read-Host -Prompt 'Enter the name of the completed file (.ps1 will be added automatically)').ps1"
    if
    (
        $Completed_File -like ""
    )
    {
        Write-Host -ForegroundColor Red "Value cannot be blank!"
        continue
    }
}
While ($true)
{
    Write-Host -Separator "`n" "Error","Info","Warning" -ForegroundColor Yellow
    if 
    (
        (Read-Host -Prompt "Enter the notification type") -notin ("Error","Info","Warning")
    )
    {
        Write-Host -ForegroundColor Red "Error in selection, try again!"
        continue
    }
    break
}

    # Creates the "System.Windows.Forms" Assembly
    Add-Type -AssemblyName System.Windows.Forms
    
    # Creates the actual "System.Windows.Forms" Object
    $message_obj = New-Object System.Windows.Forms.NotifyIcon
    
    # Path to the .exe where 'System.Drawing' extracts the icon 
    $AppName = (Get-Process -id $pid).Path
    $message_obj.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($AppName)
    
    # Type of icon to display on the left-side of the toast/balloon (Error, Info, None, Warning)
    $message_obj.BalloonTipIcon = [System.Windows.Forms.ToolTipIcon]::($Toast_Type)
    # Actual Content of the notification
    $message_obj.BalloonTipTitle = $(Get-Variable -Name Toast_Title -ValueOnly)
    $message_obj.BalloonTipText =  $(Get-Variable -Name Toast_Body -ValueOnly)
    $message_obj.Dispose()
    
    # Defines how long the tip is displayed for
    $message_obj.Visible = $true
    $message_obj.ShowBalloonTip(50000)
    
    Write-Output "
    `Add-Type -AssemblyName System.Windows.Forms
    `$message_obj=New-Object System.Windows.Forms.NotifyIcon
    `$AppName=(Get-Process -id `$pid).Path
    `$message_obj.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon(`$AppName)
    `$message_obj.BalloonTipIcon=[System.Windows.Forms.ToolTipIcon]::$($ToastType)
    `$message_obj.BalloonTipTitle=`"$($Toast_Title)`"
    `$message_obj.BalloonTipText=`"$($Toast_Body)`"
    `$message_obj.Visible=`$true
    `$message_obj.ShowBalloonTip(50000)
    `$message_obj.Dispose()" | Out-File -FilePath $Completed_File
    # Prompts whether you want to open the completed file or not.
    # If 'Yes' is clicked, 6 is returned
    # If 'No' is clicked, 7 is returned
    $response=$shell.PopUp("Export complete`n`nCompleted file is stored at $($Completed_File)`nWould you like to open the file in Notepad?",0,"Toastinator Export Status",4)
    
    
    if
    (
        $response -eq 6
    )
    {
        Start-Process notepad.exe $Completed_File
    }
    elseif
    (
        $response -eq 7
    )
    {
        break
    }
}