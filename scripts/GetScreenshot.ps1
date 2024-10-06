<#
.SYNOPSIS
    Take a screenshot and save to a specific location.
.NOTES
   Now contains updated logic for StepMania to switch from full screen to windowed mode for screenshots
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header
    
    Start-Sound ("C:\Games\Sounds\Megatouch_Click.wav")
    Write-Log "Taking screenshot..."
    
    Get-Screenshot
    Start-Sound ("C:\Games\Sounds\Megatouch_Yahoo.wav")

    Write-Log "Screenshot taken. Saved [$Global:file] to [$Global:fileDestination]."
    Write-Log "Script succeeded."
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
	exit $Script:exitCode
}