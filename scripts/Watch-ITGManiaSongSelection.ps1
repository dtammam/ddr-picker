[CmdletBinding()]
param(
    [string]$WatchPath = "C:\Users\dean\AppData\Roaming\ITGmania\Save",
    [string]$FileName  = "CurrentSongInfo.txt"
)

# Construct the full path.
$file = Join-Path $WatchPath $FileName

# Make sure the folder/file exists.
if (-not (Test-Path $WatchPath)) {
    Write-Host "ERROR: WatchPath '$WatchPath' does not exist."
    return
}

# If the file doesn't exist yet, that's okay—we'll wait for it to appear.
Write-Host "Polling file: $file"
Write-Host "Press Ctrl+C to stop."

# We'll keep track of the file's last known modification time.
$lastWriteTime = (Get-Date "1/1/1970")  # pick an old date/time so first update triggers when file is created

while ($true) {
    # If the file now exists, check its LastWriteTime.
    if (Test-Path $file) {
        $currentWriteTime = (Get-Item $file).LastWriteTime

        # If it changed since last time, read and display its contents.
        if ($currentWriteTime -gt $lastWriteTime) {
            Write-Host "`n===== $(Get-Date): File updated! ====="
            
            # We’ll try a short sleep, in case the file might still be in the middle of being written.
            Start-Sleep -Seconds 1

            try {
                $contents = Get-Content -Path $file -ErrorAction Stop
                Write-Host $contents
            }
            catch {
                Write-Warning "Failed to read file contents."
            }

            # Update our stored lastWriteTime
            $lastWriteTime = $currentWriteTime
        }
    }

    # Sleep 1 second before checking again.
    Start-Sleep 1
}
