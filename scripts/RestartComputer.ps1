<#
RestartComputer.ps1

    Goal:
        The purpose of this script is to restart your computer.

    Audience:
        People who want to be able to restart their computer.

    Version:
        8/27/2022 - Original version
        9/2/2022 - Formatted text

    Return Codes:
        Success - 0
        Failure - 1

    References:
        N/A
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Restart Computer"

# Overarching Try block for execution
Try {
    Write-Output "Cabinet: Restarting Computer in 1 second..."
    Start-Sleep -Seconds 1
    Restart-Computer
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}