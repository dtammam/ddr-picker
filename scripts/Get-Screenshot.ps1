<#PSScriptInfo

.VERSION 1.4

.AUTHOR Dean Tammam
.TAGS Get-Screenshot
.RELEASENOTES
Version 1.4: 10/30/2022 - Rewritten with boxcutter.exe
Version 1.3: 10/23/2022 - Rewritten with nircmd.exe
Version 1.2: 8/28/2022 - Added logic to 'stage' picture
Version 1.1: 8/27/2022 - Code block for sound 
Version 1.0: 8/17/2022 - Original version
#>

<#
.SYNOPSIS
    The purpose of this script is to screenshot a screen and save a file of the screenshot to a specific location.
.DESCRIPTION
    The audience is automation-oriented screenshotters.
.NOTES

#>

Function Open-Header {
    <#
    .SYNOPSIS 
        Prepares global variables.
    .DESCRIPTION
        Prepares global variables that will be used for various functions throughout the script. Specifically configured for logging locations and exit codes.
    #>
    $Global:ScriptName = 'Get-Screenshot.ps1'
    $Global:SuccessExitCode = '0'
    $Global:FailureExitCode = '1'
    $Global:LogFolderPath = "C:\Program Files\_ScriptLogs"
    $Global:LogFilePath = "$($Global:LogFolderPath)\$($Global:ScriptName).log"
    $Global:LogTailPath = "$($Global:LogFolderPath)\$($Global:ScriptName)_Transcript.log"

    if (!(Test-Path -Path $Global:LogFolderPath)) {
        New-Item -ItemType Directory -Force -Path $Global:LogFolderPath
    }
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

    Add-Content $Global:LogFilePath "$(Get-Date) - $Message"
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
        This function takes a screenshot and saves it as a file. Uses a screenshot utility and passes a pre-determined file path within the code.
    .NOTES
        The variables below can be tweaked depending on your use-case:
            - $ScreenshotApp can be modified with another application like Magick or ShareX (along with the -ArgumentList in the command itself)
            - $FilePath can be updated to your screenshot folder
    #>

    $ScreenshotApp = "C:\pegasus\scripts\exe\boxcutter-fs.exe"
    $FileName = Get-Date -Format yyyy-MM-dd_hh-mm-ss
    $FilePath = "C:\Users\me\Pictures\Archived"
    $Global:File = "$($FilePath)\$($FileName).png"
    Start-Process $ScreenshotApp -ArgumentList "$File"
    Start-Sleep -Seconds 2
    Copy-Item -Path $Global:File -Destination "C:\Users\me\Pictures\Uploads"
}

try {
    Open-Header
    Start-Transcript -Path $LogTailPath -Append
    Write-Log "`n==================================================================================================`n"
    Write-Log "Get-Screenshot.ps1: Starting script."

    Start-Sound ("C:\Games\camera-focus-beep-01.wav")
    Write-Log "Get-Screenshot.ps1: Taking screenshot..."
    Get-Screenshot
    Write-Log "Get-Screenshot.ps1: Screenshot taken. Saved to $($Global:File)."
    Start-Sound ("C:\Games\camera-shutter-click-01.wav")

    Write-Log "Get-Screenshot.ps1: Script succeeded."
    Stop-Transcript
    Exit $Global:SuccessExitCode
}

catch {
    Write-Log "Get-Screenshot.ps1: Script failed with the following exception: $($_)"
    Stop-Transcript
    Exit $Global:FailureExitCode
}