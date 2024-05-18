function Open-Header {
    <#
    .SYNOPSIS 
        Prepares variables.
    .DESCRIPTION
        Prepares global variables that will be used for various functions throughout the script. Specifically configured for logging locations and exit codes.
    .EXAMPLE
        Open-Header
    #>
    [CmdletBinding()]
    param()

    # Determine the calling script name programmatically
    $scriptName = $MyInvocation.ScriptName

    # If the script is not directly invoked, handle null case
    if (-not $scriptName) {
        $scriptName = "UnknownScript"
    } else {
        # Extract just the script name from the full path
        $scriptName = [System.IO.Path]::GetFileName($scriptName)
    }

    # Make the scriptName variable available globally
    Set-Variable -Name scriptName -Value $scriptName -Scope Global

    # Define other script-level variables
    $Script:exitCode = -1
    $Script:logFolderPath = "C:\Program Files\_ScriptLogs"
    $Script:logFilePath = "$($Script:logFolderPath)\$scriptName.log"
    $Script:logTailPath = "$($Script:logFolderPath)\$scriptName_Transcript.log"

    if (-not (Test-Path -Path $Script:logFolderPath)) {
        New-Item -ItemType Directory -Force -Path $Script:logFolderPath
    }

    # Your existing log writing and initialization logic here
    Write-Output "Header opened for script: $scriptName"
}


function Write-Log {
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
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        [ValidateNotNullOrEmpty()]
        $Message
    )

    Add-Content $Script:logFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Script:eventMessage += $Message | Out-String
}

function Start-Sound {
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
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]
        [ValidateNotNullOrEmpty()]
        $Path
    )

    $sound = New-Object System.Media.SoundPlayer
    $sound.SoundLocation=$Path
    $sound.playsync()
}

function Send-Keystrokes {
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
    [CmdletBinding()]
	param (
        [Parameter(Mandatory)]
        [string]
        [ValidateNotNullOrEmpty()]
		$SendKeys,

        [Parameter(Mandatory)]
        [string]
        [ValidateNotNullOrEmpty()]
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

function Get-Screenshot {
    <#
    .SYNOPSIS 
		Takes a screenshot.
    .DESCRIPTION
        This function takes a screenshot and saves it as a file. Uses a screenshot utility and passes a pre-determined file path within the code.
    .NOTES
        The variables below can be tweaked depending on your use-case:
            - $screenshotApp can be modified with another application like Magick or ShareX (along with the -ArgumentList in the command itself)
            - $FilePath can be updated to your screenshot folder
    #>
    [CmdletBinding()]
    param()

    $screenshotApp = "C:\pegasus\scripts\exe\boxcutter-fs.exe"
    $fileName = Get-Date -Format yyyy-MM-dd_hh-mm-ss
    $filePath = "C:\Users\me\Pictures\Archived"
    $Script:file = "$($filePath)\$($fileName).png"
    Start-Process $screenshotApp -ArgumentList "$File"
    Start-Sleep -Seconds 1
    Copy-Item -Path $Script:file -Destination "C:\Users\me\Pictures\Uploads"
}