<#
ResetLitboardLights.ps1

    Goal:
        The purpose of this script is to reset your litboard to all lights off.
        This is a bodge that works by taking advantage of Din's LightsTest.exe which starts off by showing all lights off.
        We simply open it, and close it in less than a second for the desired effect.

    Audience:
        People who want to be able to ensure that their Litboard lights aren't on excessively.

    Version:
        9/2/2022 - Original version

    Return Codes:
        Success - 0
        Failure - 1

    References:
        N/A
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Reset Litboard Lights"
$LightExe = "LightsTest"
$LightUtility = "C:\pegasus\scripts\exe\$($LightExe).exe"

# Overarching Try block for execution
Try {
    Write-Output "Cabinet: Starting light test..."
    Start-Process $LightUtility -WindowStyle Hidden
    Start-Sleep -Milliseconds 325
    Write-Output "Cabinet: Stopping light test..."
    Stop-Process -Name $LightExe
    Write-Output "Cabinet: Stopped light test."
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}