<#
StartLitForMAME.ps1

    Goal:
        The purpose of this script is to launch mame2lit.exe in an unobtrusive way.
        mame2lit.exe is required for Litboard support with MAME games. It must be opened.

    Audience:
        People who use a frontend launcher and need mame2lit.exe to launch in an unobtrusive way.

    Version:
        9/3/2022

    Return Codes:
        Success - 0
        Failure - 1

    References:
        Starting hidden processes - https://devblogs.microsoft.com/scripting/powertip-start-hidden-process-with-powershell/
#>

# Define good/bad exit codes and other relevant variables
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Start Lit For MAME"
$ExePath = 'C:\pegasus\scripts\exe\mame2lit.exe'

# Overarching Try block for execution
Try {
    # Launch mame2lit.exe
    Write-Output "Cabinet: Launching mame2lit.exe..."
    Start-Process -WindowStyle Hidden -FilePath $ExePath
    Write-Output "Cabinet: launched mame2lit.exe."

    # Clean exit
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}