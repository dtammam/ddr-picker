<#
ScreenshotCopy.ps1
    .SYNOPSIS
        The purpose of this script is to screenshot a screen and save a file of the screenshot to a specific location.
    .DESCRIPTION
        The audience is automation-oriented screenshotters.
    .NOTES
        - 10/23/2022 - Rewritten with nircmd.exe
        - 8/28/2022 - Added logic to 'stage' picture
        - 8/27/2022 - Code block for sound 
        - 8/17/2022 - Original version
#>

# Global variables for various logging functions
$Global:ScriptName = $MyInvocation.MyCommand
$Global:SuccessExitCode = '0'
$Global:FailureExitCode = '1'
$LogFolderPath = "C:\Program Files\_ScriptLogs"
$LogFilePath = "$($LogFolderPath)\$($ScriptName).log"
$Global:LogTailPath = "$($LogFolderPath)\$($ScriptName)_Transcript.log"

# Create our log directory if it doesn't exist
if (!(Test-Path -Path $LogFolderPath)) {
    New-Item -ItemType Directory -Force -Path $LogFolderPath
}

Function Write-Log($Message) {
    <#
    .SYNOPSIS 
        Writes to a log file.
    .DESCRIPTION
        Writes to a log file. Names it after the script and empowers you to use a similarly-formatted transcript file across your different scripts for reviewing results.
    .PARAMETER $Message
        The log you'd want written in the event.
    .EXAMPLE
        Write-Log "Script failed with the following exception: $($_)"
    #>

    Add-Content $LogFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Global:EventMessage += $Message | Out-String
}

Function Start-Sound ($Path) {
    <#
    .SYNOPSIS 
        This function plays a sound.
    .DESCRIPTION
        This function plays a sound. Leverages the sound player media component of Windows.
    .PARAMETER Path
        Specifies the file to play.
    #>

    $Sound = New-Object System.Media.SoundPlayer
    $Sound.SoundLocation=$Path
    $Sound.playsync()
}

Function Get-Screenshot {
    <#
    .SYNOPSIS 
        This function takes a screenshot and saves it as a file.
    .DESCRIPTION
        This function takes a screenshot and saves it as a file. Uses nircmd.exe and passes a pre-determined file path within the code.
    .NOTES
        The variables below can be tweaked depending on your use-case:
            - $ScreenshotApp can be modified with another application like Magick or ShareX (along with the -ArgumentList in the command itself)
            - $FilePath can be updated to your screenshot folder
    #>

    $ScreenshotApp = "C:\pegasus\scripts\exe\nircmd.exe"
    $FileName = Get-Date -Format yyyy-MM-dd_hh-mm-ss
    $FilePath = "C:\Users\me\Pictures\Uploads"
    $File = "$($FilePath)\$($FileName).png"
    Start-Process $ScreenshotApp -ArgumentList "savescreenshot $($File)"
}

try {
    Start-Transcript -Path $LogTailPath -Append
    Write-Log "Starting script..."

    Start-Sound ("C:\Games\camera-focus-beep-01.wav")
    Get-Screenshot
    Start-Sound ("C:\Games\camera-shutter-click-01.wav")

    Write-Log "Script succeeded."
    Stop-Transcript
    Exit $Global:SuccessExitCode
}

catch {
    Write-Log "Script failed with the following exception: $($_)"
    Stop-Transcript
    Exit $Global:FailureExitCode
}