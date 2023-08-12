<#PSScriptInfo

.VERSION 1.7

.GUID 7990f914-75e8-4f35-b0e6-71ecabf672e9   

.AUTHOR dean@tamm.am

.COMPANYNAME

.COPYRIGHT

.TAGS Get-Screenshot

.LICENSEURI

.PROJECTURI https://github.com/dtammam/ddr-picker

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES
Now contains updated logic for StepMania to switch from full screen to windowed mode for screenshots

.PRIVATEDATA

#>

<#

.DESCRIPTION
    The purpose of this script is to screenshot a screen and save a file of the screenshot to a specific location.

#>

Function Open-Header {
    <#
    .SYNOPSIS 
        Prepares variables.
    .DESCRIPTION
        Prepares global variables that will be used for various functions throughout the script. Specifically configured for logging locations and exit codes.
	.EXAMPLE
        Open-Header
    #>

    $Script:ScriptName = 'Get-Screenshot.ps1'
    $Script:ExitCode = -1
    $Script:LogFolderPath = "C:\Program Files\_ScriptLogs"
    $Script:LogFilePath = "$($Script:LogFolderPath)\$($Script:ScriptName).log"
    $Script:LogTailPath = "$($Script:LogFolderPath)\$($Script:ScriptName)_Transcript.log"

    if (!(Test-Path -Path $Script:LogFolderPath)) {
        New-Item -ItemType Directory -Force -Path $Script:LogFolderPath
    }
}

Function Write-Log($Message) {
    <#
    .SYNOPSIS 
        Writes a log.
    .DESCRIPTION
        Writes to a log file. Names it after the script and empowers you to use a similarly-formatted transcript file across your different scripts for reviewing results.
    .PARAMETER $Message
        The log you'd want written in the event.
    .EXAMPLE
        Write-Log "Script failed with the following exception: $($_)"
    #>

    Add-Content $Script:LogFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Script:EventMessage += $Message | Out-String
}

Function Start-Sound ($Path) {
    <#
    .SYNOPSIS 
        Plays a sound.
    .DESCRIPTION
        This function plays a sound. Leverages the sound player media component of Windows.
    .PARAMETER Path
        Specifies the file to play.
	.EXAMPLE
		Start-Sound ("C:\Windows\WinSxS\amd64_microsoft-windows-shell-sounds-dm_31bf3856ad364e35_10.0.22621.1_none_a9a06b326661fac0\Windows Notify Email.wav")
	#>

    $Sound = New-Object System.Media.SoundPlayer
    $Sound.SoundLocation=$Path
    $Sound.playsync()
}

Function Send-Keystrokes {
	<#
    .SYNOPSIS 
        Sends keystrokes.
    .DESCRIPTION
        This function sends keystrokes to an open window. Keystroke examples can be reviewed here: https://learn.microsoft.com/en-us/previous-versions/office/developer/office-xp/aa202943(v=office.10)?redirectedfrom=MSDN
    .PARAMETER $SendKeys
        The specific keystrokes to send.
	.PARAMETER $WindowTitle
		The window to send the keystrokes to.
    .EXAMPLE
        Send-Keystrokes -WindowTitle 'Command Prompt' -SendKeys '%{ENTER}'
    #>

	param (
		$SendKeys,
		$WindowTitle
	)

	$wshell = New-Object -ComObject wscript.shell;

	if ($WindowTitle) {
			$wshell.AppActivate($WindowTitle)
		}

	if ($SendKeys) {
		$wshell.SendKeys($SendKeys)
	}
}

Function Get-Screenshot {
    <#
    .SYNOPSIS 
		Takes a screenshot.
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
    $Script:File = "$($FilePath)\$($FileName).png"
    Start-Process $ScreenshotApp -ArgumentList "$File"
    Start-Sleep -Seconds 1
    Copy-Item -Path $Script:File -Destination "C:\Users\me\Pictures\Uploads"
}

try {
    Open-Header
    Start-Transcript -Path $LogTailPath -Append

    Start-Sound ("C:\Games\camera-focus-beep-01.wav")
    Write-Log "Taking screenshot..."

    # StepMania does not seem to play nicely when in full screened mode, momentarily make it windowed and screenshot
	if (Get-Process -Name ITGMania) {
		$wshell = New-Object -ComObject wscript.shell;
		$wshell.AppActivate('Simply Love')
        Start-Sleep -Seconds 1
		Invoke-Expression "C:\pegasus\Send-Alt+Enter.exe"
        Start-Sleep -Seconds 5
		Get-Screenshot		
        Start-Sleep -Seconds 2        
        Invoke-Expression "C:\pegasus\Send-Alt+Enter.exe"
	} else {
		Get-Screenshot
	}

    Write-Log "Screenshot taken. Saved to $($Script:File)."
    Start-Sound ("C:\Games\camera-shutter-click-01.wav")

    Write-Log "Script succeeded."
    $Script:ExitCode = 0
} catch {
    Write-Log "Script failed with the following exception: $($_)"
    $Script:ExitCode = 1
}

finally {
	Stop-Transcript
	Exit $Script:ExitCode
}