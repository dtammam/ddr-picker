<#
KillAllAndResetPegasus.ps1

    Goal:
        The purpose of this script is to reset your kiosk-style machine to its' frontend launcher.
        It will close out all pre-determined processes, then start any key ones and lanch the launcher last.

    Audience:
        People who want to be able to have access to a quick and easy way to reset their kiosk.

    Version:
        9/2/2022 - Original version
        9/5/2022 Added ITG, ITG2, ITG3, StepMania 3.9 and NotITG

    Return Codes:
        Success - 0
        Failure - 1

    References:
        N/A
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Kill All And Reset Pegasus"

# Overarching Try block for execution
Try {
    # Stop all relevant processes, with error actions set to silently continue in the event that some aren't open.
    Write-Output "Cabinet: Stopping all relevant processes..."
    Stop-Process -Name pegasus-fe -ErrorAction SilentlyContinue
    Stop-Process -Name spice -ErrorAction SilentlyContinue
    Stop-Process -Name StepMania -ErrorAction SilentlyContinue
    Stop-Process -Name mame -ErrorAction SilentlyContinue
    Stop-Process -Name mame2lit -ErrorAction SilentlyContinue
    Stop-Process -Name outfox -ErrorAction SilentlyContinue
    Stop-Process -Name gslauncher -ErrorAction SilentlyContinue
    Stop-Process -Name ITGMania -ErrorAction SilentlyContinue
    Stop-Process -Name cmd -ErrorAction SilentlyContinue
    Stop-Process -Name explorer -ErrorAction SilentlyContinue
    Stop-Process -Name OpenITG-PC -ErrorAction SilentlyContinue
    Stop-Process -Name OpenITG -ErrorAction SilentlyContinue
    Stop-Process -Name Taskmgr -ErrorAction SilentlyContinue	
    Stop-Process -Name cmd -ErrorAction SilentlyContinue -Force
    Stop-Process -Name timeout -ErrorAction SilentlyContinue	
    Stop-Process -Name notepad -ErrorAction SilentlyContinue -Force
    Stop-Process -Name notepad++ -ErrorAction SilentlyContinue -Force
    Stop-Process -Name regedit -ErrorAction SilentlyContinue -Force
    Stop-Process -Name mmc -ErrorAction SilentlyContinue -Force
    Stop-Process -Name NotITG-v4.2.0 -ErrorAction SilentlyContinue -Force
    Stop-Process -Name "In The Groove" -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*Restart iCloud Loop' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*Start Lit For MAME' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*Start MAME' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*Reset Litboard Lights' } | Stop-Process -ErrorAction SilentlyContinue -Force
    Get-Process | Where-Object { $_.MainWindowTitle -like '*Start Backend Apps' } | Stop-Process -ErrorAction SilentlyContinue -Force

    # Start all relevant processes, ensuring that the frontend launcher starts last so it is the focused window.
    Write-Output "Cabinet: Starting all relevant processes..."
    Start-Process PowerShell C:\pegasus\scripts\ResetLitboardLights.ps1 -WindowStyle Hidden
    Start-Process PowerShell C:\Pegasus\scripts\RestartiCloudLoop.ps1 -WindowStyle Minimized
    Start-Process C:\pegasus\pegasus-fe.exe
    Write-Output "Cabinet: Started all relevant processes."
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}