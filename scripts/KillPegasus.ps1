<#
KillPegasus.ps1

    Goal:
        The purpose of this script is to kill your front-end launcher when a game is started.

    Audience:
        People who want to be able to quickly kill the front-end before a specified game launches.

    Version:
        9/3/2022 - Original version

    Return Codes:
        Success - 0
        Failure - 1

    References:
        N/A
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Kill Pegasus"

# Overarching Try block for execution
Try {
    # Stop all relevant processes, with error actions set to silently continue in the event that some aren't open.
    Write-Output "Cabinet: Stopping all relevant processes..."
    Stop-Process -Name pegasus-fe -ErrorAction SilentlyContinue
    Write-Output "Cabinet: Stoped all relevant processes."
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}