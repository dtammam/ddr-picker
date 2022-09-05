<#
StartBackendApps.ps1

    Goal:
        The purpose of this script is to act as a 'Startup' for Windows apps that will no longer work without explorer.

    Audience:
        People who want to be able to 'normally' startup apps and processes without explorer.exe

    Version:
        8/27/2022 - Original version
        9/2/2022 - Conversion from .bat to .ps1

    Return Codes:
        Success - 0
        Failure - 1

    References:
        N/A
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Start Backend Apps"

# Overarching Try block for execution
Try {
    Write-Output "Starting all backend services..."
    Start-Process "C:\Program Files (x86)\AudioSwitch\AudioSwitch.exe"
    Start-Process "C:\Program Files (x86)\Common Files\Apple\Internet Services\iCloudPhotos.exe"
    Start-Process "C:\Program Files (x86)\Common Files\Apple\Internet Services\iCloudServices.exe"
    Write-Output "All backend services started successfully."
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}