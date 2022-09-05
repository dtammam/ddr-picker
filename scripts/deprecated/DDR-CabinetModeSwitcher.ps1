$RegFileLocation = "C:\pegasus\scripts"
$RegGame = "C:\pegasus\scripts\ShellToGame.reg"
$RegPC = "C:\pegasus\scripts\ShellToPC.reg"
$Process = "explorer"
$ExplorerRunning = Get-Process $Process -ErrorAction SilentlyContinue

If ($ExplorerRunning) {
    Write-Output "Changing registry to run in kiosk mode"
    Invoke-Command {reg import $RegGame | Out-Null} -ErrorAction SilentlyContinue
    Stop-Process -Name $Process -Force
    Write-Output "PC set to run in kiosk mode, please reboot for it to take effect."
}

Else {
    Write-Output "Changing registry to run in desktop mode"
    Invoke-Command {reg import $RegPC | Out-Null} -ErrorAction SilentlyContinue
    Add-Type -AssemblyName PresentationCore,PresentationFramework
    Write-Output "PC set to run in desktop mode, please reboot for it to take effect."
}