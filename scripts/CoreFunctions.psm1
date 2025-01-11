function Get-Screenshot {
    <#
    .SYNOPSIS 
        Takes a screenshot.
    .DESCRIPTION
        This function takes a screenshot and saves it as a file. Uses MiniCap for capturing the screenshot.
    .NOTES
        The variables below can be tweaked depending on your use-case:
        - $screenshotApp can be modified with another application like Magick or ShareX (along with the -ArgumentList in the command itself)
        - $FilePath can be updated to your screenshot folder
        - This whole thing would benefit from config-as-code, but not now.
    #>
    [CmdletBinding()]
    param()

    $screenshotApp = "C:\pegasus\scripts\exe\MiniCap.exe"
    $Global:fileName = Get-Date -Format yyyy-MM-dd_hh-mm-ss
    $Global:filePath = "C:\Users\me\Pictures\Archived"
    $Global:file = "$($Global:filePath)\$($Global:fileName).png"
    $Global:fileDestination = "C:\Users\me\Pictures\Uploads"

    # Take the screenshot of the main monitor, reduce size by 10% for speed and space and save
    Start-Process $screenshotApp -ArgumentList "-save `"$Global:file`" -capturescreen -capturemon 0 -resizexp 90 -resizeyp 90 -exit"

    # Wait a moment for the process to complete
    Start-Sleep -Seconds 1

    # Copy the screenshot to another destination if needed
    Copy-Item -Path $Global:file -Destination $Global:fileDestination
}

<#
.SYNOPSIS
    Updates the marquee display by reading a file for a banner image path.
.DESCRIPTION
    This function reads a specified file to find a line containing a banner image path. It then updates the marquee display by opening the image in fullscreen mode using the Open-FullscreenImage function.
.PARAMETER FilePath
    The path to the file that contains the banner image path.
.EXAMPLE
    Invoke-SetMarqueeFromFile -FilePath "C:\Users\dean\AppData\Roaming\ITGmania\Save\CurrentSongInfo.log"
.NOTES
    Ensure that the file contains a line with the format 'Banner: <image_path>'.
#>
function Invoke-SetMarqueeFromFile {
    param (
        [string]$FilePath
    )

    try {
        # Read the file contents
        $contents = Get-Content -Path $FilePath -ErrorAction Stop

        # Find the line that contains the banner path
        $bannerLine = $contents | Where-Object { $_ -match 'Banner:' }

        if ($bannerLine) {
            # Extract the file path from the banner line
            $bannerPath = $bannerLine -replace '.*Banner:\s*', ''

            # Update the marquee display
            Stop-Process -Name 'i_view64' -ErrorAction SilentlyContinue
            Open-FullscreenImage -Image $bannerPath
            Start-Sleep -Seconds 2
            Set-ForegroundWindow -Window 'Simply Love'
        } else {
            Write-Warning "No banner line found in the file."
        }
    } catch {
        Write-Warning "Failed to process the file: $($_.Exception.Message)"
    }
}


function Open-Header {
    <#
    .SYNOPSIS 
        Prepares variables.
    .DESCRIPTION
        Prepares global variables that will be used for various functions throughout the script. 
        Specifically configured for logging locations and exit codes.
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

    # Set the window title
    $Host.UI.RawUI.WindowTitle = $scriptName

    # Define other script-level variables
    $Script:exitCode = -1
    $Script:logFolderPath = "C:\Program Files\_scriptLogs"
    $Script:logFilePath = "$($Script:logFolderPath)\$scriptName.log"
    $Script:logTailPath = "$($Script:logFolderPath)\$scriptName_Transcript.log"

    # Create our log folder directory if it doesn't exist
    if (-not (Test-Path -Path $Script:logFolderPath)) {
        New-Item -ItemType Directory -Force -Path $Script:logFolderPath
    }

    # Your existing log writing and initialization logic here
    Write-Log "Header opened for script: [$scriptName]"
}

function Open-FullscreenImage {
    <#
    .SYNOPSIS 
        Opens an image in fullscreen mode.
    .DESCRIPTION
        Sets an image file to display on a 2nd monitor. Primary usecase is to act as a dynamic marquee.
    .PARAMETER Image
        The image you'd like to display.
    .EXAMPLE
        Open-FullscreenImage -Image "C:\Images\DDRA20.jpeg"
    .NOTES
        Requires specific Ifranview preferences to be set:
        - In Options -> Properties/Settings -> Full screen / Slideshow:
        1. Within `Full screen/Slideshow display options` , choose `Stretch all images/movies to screen (4)`
        2. Under `Full screen only` options, uncheck `Show text`

        - Open an image, move Irfanview to the correct monitor, full screen, reduce size and then graceully exit. 
        This configures the .ini file to launch within the correct monitor (due to the now saved coordinates.) 
        Full screen will launch it on the right screen!
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Image
    )

    try {
        $imageLauncherApp = "C:\Program Files\IrfanView\i_view64.exe"
        Start-Process $imageLauncherApp -ArgumentList "`"$($Image)`" /fs"
    } catch { }
}

function Send-Keystrokes {
    <#
    .SYNOPSIS 
        Sends keystrokes.
    .DESCRIPTION
        This function sends keystrokes to an open window. 
    .PARAMETER SendKeys
        The specific keystrokes to send.
    .PARAMETER WindowTitle
        The window to send the keystrokes to.
    .EXAMPLE
        Send-Keystrokes -WindowTitle 'Command Prompt' -SendKeys '%{ENTER}'
    .LINK
        Keystroke examples can be reviewed here: https://learn.microsoft.com/en-us/previous-versions/office/developer/office-xp/aa202943(v=office.10)?redirectedfrom=MSDN
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$SendKeys,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$WindowTitle
    )

    # Select our window and send keys
    $wshell = New-Object -ComObject wscript.shell;
    if ($WindowTitle) { $wshell.AppActivate($WindowTitle) }
    if ($SendKeys) { $wshell.SendKeys($SendKeys) }
}

function Set-ForegroundWindow {
    <#
    .SYNOPSIS
        Brings a specified window to the foreground.
    .DESCRIPTION
        The Set-ForegroundWindow function takes the title of a window as a parameter and attempts to bring that window to the foreground. 
        If the window is minimized, it will be restored before being brought to the foreground. This can be particularly useful 
        when automating tasks that require interaction with a specific window.
    .PARAMETER WindowName
        The exact title of the window you want to bring to the foreground. This parameter is mandatory.
    .EXAMPLE
        Set-ForegroundWindow -WindowName "Untitled - Notepad"
        
        This example brings a Notepad window with the title "Untitled - Notepad" to the foreground.
    .NOTES
        Ensure that the specified window title is correct, as this function is case-sensitive and requires an exact match.
    .LINK
        https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-setforegroundwindow
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$WindowName
    )

    try {
        # Define a C# class to interact with user32.dll functions (necessary for window manipulation).
        Add-Type @"
            using System;
            using System.Runtime.InteropServices;

            public class User32 {
                // Import functions for window handling from user32.dll.
                [DllImport("user32.dll", SetLastError = true)]
                [return: MarshalAs(UnmanagedType.Bool)]
                public static extern bool SetForegroundWindow(IntPtr hWnd);
                
                [DllImport("user32.dll")]
                public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);
                
                [DllImport("user32.dll")]
                public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

                [DllImport("user32.dll", SetLastError = true)]
                public static extern IntPtr SetFocus(IntPtr hWnd);

                public const int SW_RESTORE = 9;
            }
"@
        # Find the window handle (hWnd) for the specified window name.
        $hwnd = [User32]::FindWindow([NullString]::Value, $WindowName)

        if ($hwnd -ne [IntPtr]::Zero) {
            # Restore the window if minimized and bring it to the foreground.
            [User32]::ShowWindow($hwnd, [User32]::SW_RESTORE)
            [User32]::SetFocus($hwnd) # Set focus to the window to bring it to the front.
            [User32]::SetForegroundWindow($hwnd)
            Write-Host "Window [$WindowName] brought to foreground."
        } else {
            # Notify if the window isn't found.
            Write-Host "Window [$WindowName] not found."
        }
    } catch {}
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
        [ValidateNotNullOrEmpty()]
        [string]$Path
    )

    $sound = New-Object System.Media.SoundPlayer
    $sound.SoundLocation=$Path
    $sound.playsync()
}

function Write-Log {
    <#
    .SYNOPSIS 
        Writes a log.
    .DESCRIPTION
        Writes to a log file. Names it after the script and empowers you to use a similarly-formatted transcript file across your different scripts for reviewing results.
    .PARAMETER Message
        The log you'd want written in the event.
    .EXAMPLE
        Write-Log "Script failed with the following exception: $($_.Message)"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$Message
    )

    Add-Content $Script:logFilePath "$(Get-Date) - $Message"
    Write-Output $Message
    $Script:eventMessage += $Message | Out-String
}