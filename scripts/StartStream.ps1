<#
.SYNOPSIS
    Start stream.
.NOTES
    Start the LogiCapture software for camera positioning, then launch OBS.
.LINK
    Starting hidden processes - https://devblogs.microsoft.com/scripting/powertip-start-hidden-process-with-powershell/
#>

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

# Variable declaration
[string]$webcamExecutablePath = 'C:\Program Files\Logitech\LogiCapture\bin\LogiCapture.exe'
[string]$broadcasterExecutableBasePath = 'C:\Program Files\obs-studio\bin\64bit'
[string]$broadcasterExecutableFileName = 'obs64.exe'
[string]$broadcasterExecutableFullPath = Join-Path -Path $broadcasterExecutableBasePath -ChildPath $broadcasterExecutableFileName

try {
    Open-Header

    # Launch LogiCapture for the camera to be in the appropriate position
    Write-Log "Launching LogiCapture software..."
    Start-Process -WindowStyle Hidden -FilePath $webcamExecutablePath
    Write-Log "Launched LogiCapture software."
    
    # Launch OBS to begin streaming.
    Write-Log "Launching OBS software..."
    Set-Location -Path $broadcasterExecutableBasePath
    Start-Process -FilePath $broadcasterExecutableFullPath -ArgumentList "--startstreaming --disable-shutdown-check"
    Write-Log "Launched OBS software."

    # Play the fun Megatouch sound to indicate that the process has started!
    Start-Sound ("C:\Games\Megatouch_PhotoHunt_Yippee.wav")

    # Wait a few seconds and then switch focus back to Pegasus so that the player can start playing
    Start-Sleep -Seconds 5
    Set-ForegroundWindow -WindowName 'Pegasus'
    
    $Script:exitCode = 0
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}