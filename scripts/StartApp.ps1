<#
.SYNOPSIS
    Start a specified app.
.NOTES
    Start a target process programmatically.
.LINK
    Starting hidden processes - https://devblogs.microsoft.com/scripting/powertip-start-hidden-process-with-powershell/
#>

[CmdletBinding()]
param (
    [string]$ExecutableFullPath
)

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header

    # Launch process
    Write-Log "Starting process [$($ExecutableFullPath)]..."
    Start-Process -FilePath $ExecutableFullPath
    Write-Log "Launched process [$($ExecutableFullPath)]."
    Start-Sound ("C:\Games\Sounds\Megatouch_Tap.wav")
    
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}