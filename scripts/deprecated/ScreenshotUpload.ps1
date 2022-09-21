<#
ScreenshotCopy.ps1

    Goal:
        The purpose of this script is to screenshot a screen and save a file of the screenshot to a specific location.
        This is agnostic and will take a picture by leveraging .NET capabilities, ignoring any screenshot functions within programs themselves.

    Audience:
        Automation-oriented screenshotters.

    Version:
        8/17/2022 - Original version
        8/27/2022 - Code block for sound to screenshot and upload

    Return Codes:
        Success - 0
        Failure - 1

    References:
        Image saving logic - https://docs.microsoft.com/en-us/dotnet/api/system.drawing.image.save?view=dotnet-plat-ext-6.0
        Playing a sound with a .NET call - https://devblogs.microsoft.com/scripting/powertip-use-powershell-to-play-wav-files/
#>

# Global variables for various logging functions
$ScriptName = $MyInvocation.MyCommand
$LogFolderPath = "C:\Program Files\_ScriptLogs"
$LogFilePath = "$($LogFolderPath)\$($ScriptName).log"
$LogTailPath = "$($LogFolderPath)\$($ScriptName)_Transcript.log"

# Create our log directory if it doesn't exist
if (!(Test-Path -Path $LogFolderPath)) {
        New-Item -ItemType Directory -Force -Path $LogFolderPath
}

# Primary logging function
function Write-Log($Message) {
        Add-Content $LogFilePath "$(Get-Date) - $Message"
        Write-Output $Message
        $Global:EventMessage += $Message | Out-String
    }

# Overarching Try block for execution
try {
    # Begin a tail for logging non-implicitly captured events from the terminal
    Start-Transcript -Path $LogTailPath -Append

    # Prep variables for the file we'll create
    $FileName = Get-Date -Format yyyy-MM-dd_hh-mm
    $File = "C:\Users\me\Pictures\Uploads\$($FileName).jpg"

    # Add assembly references
    Add-Type -AssemblyName System.Windows.Forms
    Add-type -AssemblyName System.Drawing

    # Map out screen resolution and corners
    $Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
    $Width = $Screen.Width
    $Height = $Screen.Height
    $Left = $Screen.Left
    $Top = $Screen.Top

    # Create the bitmap using the top-left and bottom-right bounds
    $Bitmap = New-Object System.Drawing.Bitmap $Width, $Height

    # Create a graphics object for collection
    $GraphicObject = [System.Drawing.Graphics]::FromImage($Bitmap)

    # Capture the content on screen
    $GraphicObject.CopyFromScreen($Left, $Top, 0, 0, $Bitmap.Size)

    # Play a sound to confirm the picture being taken
    $PlayBeep = New-Object System.Media.SoundPlayer
    $PlayBeep.SoundLocation="C:\Games\camera-focus-beep-01.wav"
    $PlayBeep.playsync()

    # Save to a .jpg file
    $Bitmap.Save($File)
    # Play a sound to confirm the picture being uploaded
    $PlayShutter = New-Object System.Media.SoundPlayer
    $PlayShutter.SoundLocation="C:\Games\camera-shutter-click-01.wav"
    $PlayShutter.playsync()
    Write-Log "Screenshot saved to $($File)"
    Write-Log $File

    # Cleanup and exit script
    Write-Log "Script complete."
    Stop-Transcript
    Exit 0
}

# Overarching catch block for error handling
catch {
    # Cleanup and exit script
    Write-Log "Script failed with the following exception: $($_)"
    Stop-Transcript
    Exit 1
}

$user = 'deantammam@icloud.com'
$pass = 'Doyouwanttobuildasnowman6^'
$pair = "$($user):$($pass)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))

$basicAuthValue = "Basic $encodedCreds"

$Headers = @{
    Authorization = $basicAuthValue
}

Invoke-WebRequest -Uri 'https://whatever' -Headers $Headers





$File = "C:\WOWOWOWOW.jpg"
$uri = "https://p24-uploadimagews.icloud.com/upload?filename=$($File)"


Invoke-WebRequest -uri $uri -Method Options -Infile $File -ContentType 'image/jpg'
Invoke-WebRequest -uri $uri -Method Post -Infile $File -ContentType 'image/jpg' -UserAgent "PowerShell" -Headers $Headers
# Invoke-RestMethod $uri <#-Credential $credential#> -Method Post -Body $body -ContentType "application/json" 

$username = "username"
$securePwd = ConvertTo-SecureString "password" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($username, $securePwd)
$body = "{ ... }"
$url = "https://mysite.scm.azurewebsites.net/deploy"

Invoke-RestMethod $url -Credential $credential  -Method Post -Body $body -ContentType "application/json" -UserAgent "myuseragent"




















usercreds = Get-Credential
$picPath = "C:\Users\me\Pictures\Uploads\2022-09-09_08-54.jpg"
$uri = "https://p24-uploadimagews.icloud.com/upload?filename=$($FIle)"

Invoke-WebRequest -uri $uri -Method Post -Infile $picPath -ContentType 'image/jpg' -Credential $usercreds