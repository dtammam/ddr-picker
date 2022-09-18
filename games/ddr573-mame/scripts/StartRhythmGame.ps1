<#
StartRhythmGame.ps1

    Goal:
        The purpose of this script is to start a rhythm game!
        It will kill its' frontend launcher and start the game.

    Audience:
        People who want to be able to launch their game via .ps1 script!

    Version:
        9/4/2022 - Original version
        9/18/2022 - Minor adjustment to open minimized taskkill

    Return Codes:
        Success - 0
        Failure - 1

    References:
        N/A
#>

# Parameters to launch the .exe from a command line
Param (
    [String]$Global:Exe = (Read-Host "Please input path and .exe file.")
)

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "StartInTheGroove2"

# Overarching Try block for execution
Try {
    Write-Output "Killing the frontend launcher..."
    Start-Process PowerShell C:\pegasus\scripts\KillPegasus.ps1 -WindowStyle Hidden
    # PowerShell.exe "C:\pegasus\scripts\KillPegasus.ps1"

    Write-Output "Starting the game..."
    Start-Process $Global:Exe
    Write-Output "Game started."
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}