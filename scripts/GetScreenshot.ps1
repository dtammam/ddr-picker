<#
.SYNOPSIS
    Take a screenshot and save to a specific location.
.NOTES
   Now contains updated logic for StepMania to switch from full screen to windowed mode for screenshots
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
$Host.UI.RawUI.WindowTitle = $scriptName

try {
    Open-Header
    
    Start-Sound ("C:\Games\Megatouch_Click.wav")
    Write-Log "Taking screenshot..."

    # StepMania does not seem to play nicely when in full screened mode, momentarily make it windowed and screenshot
	if (Get-Process -Name ITGMania -ErrorAction SilentlyContinue) {
        Write-Log "ITGMania detected."
		$wshell = New-Object -ComObject wscript.shell;
		$wshell.AppActivate('Simply Love')
        Start-Sleep -Seconds 1
		Invoke-Expression "C:\pegasus\Send-Alt+Enter.exe"
        Start-Sleep -Seconds 4
        Start-Sound ("C:\Games\Megatouch_ShutterComplete.wav")
		Get-Screenshot		
        Start-Sleep -Seconds 1        
        Invoke-Expression "C:\pegasus\Send-Alt+Enter.exe"
        Start-Sound ("C:\Games\Megatouch_Yahoo.wav")
	} else {
        Write-Log "ITGMania not detected."
		Get-Screenshot
        Start-Sound ("C:\Games\Megatouch_Yahoo.wav")
	}

    Write-Log "Screenshot taken. Saved [$Global:file] to [$Global:fileDestination]."
    Write-Log "Script succeeded."
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
	exit $Script:exitCode
}