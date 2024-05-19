<#
.SYNOPSIS
    Act as a 'Startup' for Windows apps that will no longer work without explorer.
.NOTES
    Critical for non-standard services that are required.
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName

try {
    Open-Header

    Write-Log "Starting all backend services..."
    Start-Process "C:\Program Files (x86)\AudioSwitch\AudioSwitch.exe"
    Start-Process "C:\Program Files (x86)\Common Files\Apple\Internet Services\iCloudPhotos.exe"
    Start-Process "C:\Program Files (x86)\Common Files\Apple\Internet Services\iCloudServices.exe"
    Write-Log "All backend services started successfully."

    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}