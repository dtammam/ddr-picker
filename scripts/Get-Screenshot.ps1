<#PSScriptInfo

<<<<<<< HEAD
.VERSION 1.6
=======
.VERSION 1.5
>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e

.AUTHOR Dean Tammam

.TAGS Get-Screenshot

.RELEASENOTES
<<<<<<< HEAD
Version 1.6: 12/18/2022 - Updated logic for StepMania to switch from full screen to windowed mode for screenshots
=======
>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e
Version 1.5: 12/15/2022 - Updated try/catch/finally, starting CSharp for Alt + Enter to screenshot windowed
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
        Prepares variables.
    .DESCRIPTION
        Prepares global variables that will be used for various functions throughout the script. Specifically configured for logging locations and exit codes.
	.EXAMPLE
        Open-Header
    #>
<<<<<<< HEAD

    $Script:ScriptName = 'Get-Screenshot.ps1'
    $Script:ExitCode = -1
    $Script:LogFolderPath = "C:\Program Files\_ScriptLogs"
    $Script:LogFilePath = "$($Script:LogFolderPath)\$($Script:ScriptName).log"
    $Script:LogTailPath = "$($Script:LogFolderPath)\$($Script:ScriptName)_Transcript.log"

=======
    $Script:ScriptName = 'Get-Screenshot.ps1'
    $Script:ExitCode = -1
    $Script:LogFolderPath = "C:\Program Files\_ScriptLogs"
    $Script:LogFilePath = "$($Script:LogFolderPath)\$($Script:ScriptName).log"
    $Script:LogTailPath = "$($Script:LogFolderPath)\$($Script:ScriptName)_Transcript.log"

>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e
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
<<<<<<< HEAD
		Takes a screenshot.
	.DESCRIPTION
=======
        This function takes a screenshot and saves it as a file.
    .DESCRIPTION
>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e
        This function takes a screenshot and saves it as a file. Uses a screenshot utility and passes a pre-determined file path within the code.
    .NOTES
        The variables below can be tweaked depending on your use-case:
            - $ScreenshotApp can be modified with another application like Magick or ShareX (along with the -ArgumentList in the command itself)
            - $FilePath can be updated to your screenshot folder
    #>

    $ScreenshotApp = "C:\pegasus\scripts\exe\boxcutter-fs.exe"
    $FileName = Get-Date -Format yyyy-MM-dd_hh-mm-ss
<<<<<<< HEAD
    $FilePath = "C:\Users\me\Pictures\Archived"
	#$FilePath = "C:\Users\Dean\OneDrive\Pictures\Archived"
    $Script:File = "$($FilePath)\$($FileName).png"
    Start-Process $ScreenshotApp -ArgumentList "$File"
    Start-Sleep -Seconds 2
    Copy-Item -Path $Script:File -Destination "C:\Users\me\Pictures\Uploads"
	#Copy-Item -Path $Script:File -Destination "C:\Users\dean\OneDrive\Pictures\Uploads"
=======
    # $FilePath = "C:\Users\me\Pictures\Archived"
	$FilePath = "C:\Users\Dean\OneDrive\Pictures\Archived"
    $Script:File = "$($FilePath)\$($FileName).png"
    Start-Process $ScreenshotApp -ArgumentList "$File"
    Start-Sleep -Seconds 2
    # Copy-Item -Path $Script:File -Destination "C:\Users\me\Pictures\Uploads"
	Copy-Item -Path $Script:File -Destination "C:\Users\dean\OneDrive\Pictures\Uploads"
>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e

}

try {
    Open-Header
    Start-Transcript -Path $LogTailPath -Append

    Start-Sound ("C:\Games\camera-focus-beep-01.wav")
<<<<<<< HEAD
    Write-Log "Taking screenshot..."

	if (Get-Process -Name ITGMania) {
		$wshell = New-Object -ComObject wscript.shell;
		$wshell.AppActivate('Simply Love')
		Invoke-Expression "C:\pegasus\Send-Alt+Enter.exe"
		Start-Sleep -Seconds 5
		Get-Screenshot
		Start-Sleep -Seconds 3
		Invoke-Expression "C:\pegasus\Send-Alt+Enter.exe"
	}

	else {
		Get-Screenshot
	}

    Write-Log "Screenshot taken. Saved to $($Script:File)."
    Start-Sound ("C:\Games\camera-shutter-click-01.wav")

    Write-Log "Script succeeded."
=======
    Write-Log "Get-Screenshot.ps1: Taking screenshot..."
    Get-Screenshot
    Write-Log "Get-Screenshot.ps1: Screenshot taken. Saved to $($Script:File)."
    Start-Sound ("C:\Games\camera-shutter-click-01.wav")

    Write-Log "Get-Screenshot.ps1: Script succeeded."
>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e
    $Script:ExitCode = 0
}

catch {
<<<<<<< HEAD
    Write-Log "Script failed with the following exception: $($_)"
=======
    Write-Log "Get-Screenshot.ps1: Script failed with the following exception: $($_)"
>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e
    $Script:ExitCode = 1
}

finally {
	Stop-Transcript
	Exit $Script:ExitCode
<<<<<<< HEAD
}
=======
}

# Test block for Alt + Enter if not DDR. To do:
# 1. Finalize code snippet for proper SendKEys of ALt Enter
# 2. Put in an if check for if (!DDR), do this, else continue
# 3. Standardize and cleanup C# code inclusion
$AltEnter = @"
using System;
namespace AltEnter
{
	public class Program
	{
		public static void Main(){
			Console.WriteLine("Hello world!");
			// SendKeys.Send(%{ENTER});
		}
	}
}
"@
 
Add-Type -TypeDefinition $AltEnter -Language CSharp	
Invoke-Expression "[AltEnter.Program]::Main()"
>>>>>>> 3151a020bda87ff2cc31064735b36fa54984f45e
