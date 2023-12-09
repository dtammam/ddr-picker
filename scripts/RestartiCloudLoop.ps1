<#
RestartiCloudLoop.ps1

    Goal:
        The purpose of this script is to actually make iCloud Photo uploads consistent from a Windows machine.
        I'm not sure if you use an iPhone with iCloud for your cloud photo storage while also managing pictures from Windows computers... but if you have, you know it's not great.
        If you've struggled like me (seeing it behave inconsistently, downright not working at times), then this script might help you. It does the following:

        - Creates a neverending loop which
            - Stops iCloud Services 
            - Stops iCloud Photos
            - Starts iCloud Services
            - Starts iCloud Photos
            - Waits 5 minutes
            - Goes to your Uploads and deletes everything inside
            - Restarts the loop

        The reason why is because the only way I found iCloud on Windows to work consistently was with starting and stopping it very regularly.
        The 5 minute delay is to give your device time to receive photos and actually upload them. If you find photos on your phone that you'd rather delete... they'll come back if still in the uploads folder after a service restart - which is why this deletes them from 'Uploads' each go around.

        My use-case was for a Dance Dance Revolution machine with a button to take a photo and save into Uploads. I figure this could be useful for similar utility machine use-cases or even just general better behavior for photographers or others who need Windows and iCloud for a workflow.

    Audience:
        People who use iCloud Photos on a Windows device and need uploads to be more regular/consistent.

    Version:
        8/27/2022 - Original version
        9/2/2022 - Conversion from .bat to .ps1
        9/23/2022 - Added logic to save photos to an Archived directory before deleting from Uploads
        10/30/2022 - Removed archive logic as its' now handled in Get-Screenshot.exe
        12/9/2023 - Updated logic to make it so that failing to delete due to a file being uploaded isn't a hard exception

    Return Codes:
        Success - 0
        Failure - 1

    References:
        One example post that demonstrates the issue - https://www.reddit.com/r/iCloud/comments/lptouf/icloud_photos_for_windows/
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Restart iCloud Loop"

# Overarching Try block for execution
Try {
    # Completely arbitrary variable that will never change
    $Loop = "Yes, please"

    # A neverending While loop with our arbitrary variable to make this script run indefinitely
    While ($Loop -eq "Yes, please") {
        Write-Output "iCloud Fix: Loop started."
        
        # Create variables for folders, processes and sleep times
        $ApplePath = "C:\Program Files (x86)\Common Files\Apple\Internet Services\"
        $iCloudServices = "iCloudServices"
        $iCloudPhotos = "iCloudPhotos"
        
        # Close iCloud Services
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Stopping $($iCloudServices)..."
        Start-Sleep -Seconds 2
        If (!(Get-Process "$iCloudServices" -ErrorAction SilentlyContinue)) {
            Write-Output "iCloud Fix: $($iCloudServices) not running. Continuing..."
        }
        Else {
            Stop-Process -Name $iCloudServices -Force -ErrorAction SilentlyContinue
            Write-Output "iCloud Fix: Stopped $($iCloudServices)..."
        }
        
        # Close iCloud Photos
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Stopping $($iCloudPhotos)..."
        Start-Sleep -Seconds 2
        If (!(Get-Process "$iCloudPhotos" -ErrorAction SilentlyContinue)) {
            Write-Output "iCloud Fix: $($iCloudPhotos) not running. Continuing..."
        }
        Else {
            Stop-Process -Name $iCloudPhotos -Force -ErrorAction SilentlyContinue
            Write-Output "iCloud Fix: Stopped $($iCloudPhotos)..."
        }
        
        # Start iCloud Services
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Starting $($iCloudServices)..."
        Start-Sleep -Seconds 2
        Start-Process $Applepath\"$iCloudServices.exe"
        Write-Output "iCloud Fix: Started $($iCloudServices) successfully."

        # Start iCloud Photos
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Starting $($iCloudPhotos)..."
        Start-Sleep -Seconds 2
        Start-Process $ApplePath\"$iCloudPhotos.exe"
        Write-Output "iCloud Fix: Started $($iCloudPhotos) successfully."

        # Wait to give time for photos to be taken/uploaded, set variables for Uploads directory
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Waiting 5 minutes to delete photos and restart the loop."
        Start-Sleep -Seconds 300
        $PhotoUploadPath = "C:\Users\me\Pictures\Uploads\"
        $Photos = (Get-ChildItem $PhotoUploadPath -Recurse).FullName

        # Recurse through the Uploads directory and delete all items in it
        Foreach ($Photo in $Photos) {
            try {
                Remove-Item -Path $Photo
                Write-Output "iCloud Fix: Successfully deleted $($Photo) in $($PhotoUploadPath)." -ErrorAction Stop
                $DeletedCount += 1
            } catch {
                Write-Warning "Failed to delete $($Photo) with the following exception: $($_.Exception)"
            }
            Write-Output "iCloud Fix: Successfully deleted $($DeletedCount) photos."
            Continue
        }
        # Restart the loop
        Start-Sleep -Seconds 2
        Write-Output "iCloud Fix: Restarting the loop..."
    }

    # Clean exit in the event that this ever exits cleanly
    Write-Output "This should never have ended. But if it did... it was graceful."
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}