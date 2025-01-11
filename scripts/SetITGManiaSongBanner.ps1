<#
.SYNOPSIS
    Monitors a file for changes and updates the marquee image accordingly.
.DESCRIPTION
    This script watches a specified file for changes. When the file is updated, it reads the file to find a banner line, extracts the image path, and updates the marquee display using the Open-FullscreenImage function.
.PARAMETER WatchPath
    The directory path to watch for the file.
.PARAMETER FileName
    The name of the file to monitor for changes.
.EXAMPLE
    .\Watch-ITGManiaSongSelection.ps1 -WatchPath "C:\Users\dean\AppData\Roaming\ITGmania\Save" -FileName "CurrentSongInfo.log"
.NOTES
    Ensure that the CoreFunctions module is available and properly configured.
#>
[CmdletBinding()]
param(
    [string]$WatchPath = "C:\Users\dean\AppData\Roaming\ITGmania\Save",
    [string]$FileName = "CurrentSongInfo.log"
)

# Import core modules relevant for all scripts
[string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
Import-Module -Name $coreFunctionsModule -Force

try {
    Open-Header

    # Construct the full path to the file.
    $file = Join-Path $WatchPath $FileName

    # Verify that the folder exists.
    if (-not (Test-Path $WatchPath)) {
        Write-Log "ERROR: WatchPath [$WatchPath] does not exist."
        return
    }

    # Create the file if it doesn't exist.
    if (-not (Test-Path $WatchPath\$FileName -PathType Leaf)) {
        New-Item $WatchPath\$FileName -Force
    }

    # Inform the user that the script is polling the file.
    Write-Log "Polling file: [$file]"

    # Initialize the last known modification time to the current last write time of the file, if it exists.
    if (Test-Path $file) {
        $lastWriteTime = (Get-Item $file).LastWriteTime
    } else {
        # If the file doesn't exist, set to a very old date to ensure it triggers when the file is created.
        $lastWriteTime = (Get-Date "1/1/1970")
    }

    # Continuously monitor the file for changes.
    while ($true) {
        if (Test-Path $file) {
            $currentWriteTime = (Get-Item $file).LastWriteTime

            # If the file has been updated, process its contents.
            if ($currentWriteTime -gt $lastWriteTime) {
                Write-Log "`n===== $(Get-Date): File updated! ====="
                Invoke-SetMarqueeFromFile -FilePath "C:\Users\dean\AppData\Roaming\ITGmania\Save\CurrentSongInfo.log"

                # Short sleep to ensure the file is not being written to.
                Start-Sleep -Seconds 1

                $lastWriteTime = $currentWriteTime
            }
        }

        Start-Sleep 1
    }
} catch {
    Write-Log "Script failed with the following exception: [$($_.Message)]"
    $Script:exitCode = 1
} finally {
    exit $Script:exitCode
}