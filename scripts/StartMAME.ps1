<#
StartMAME.ps1

    Goal:
        The purpose of this script is to launch MAME.exe in an unobtrusive way.
        MAME.exe is required for launching 573 rhythm games and it must be opened, using the ROM and save state as arguments.

        An example of a legacy (.cmd, .bat, .vbs, etc.) way of doing it would be:

            run mame.exe ddrexproc -state o

        An example of the modern (.ps1) way when launched from .ahk is:

            Run, PowerShell -File "C:\pegasus\scripts\StartMAME.ps1" "ddrexproc -state o"

        This is close to functionally identical, with motives for this iteration being:
        
            1. It is written in Microsoft's latest scripting language and will likely remain functional for longer
            2. It is written in a way to allow passing arguments for things like AutoHotKey
            3. Being in PowerShell, it is more friendly with other scripting languages/software (like Python) versus .bat

    Audience:
        People who use a frontend launcher and need MAME.exe to launch in an unobtrusive way.

    Version:
        9/3/2022 - Original version

    Return Codes:
        Success - 0
        Failure - 1

    References:
        Starting hidden processes - https://devblogs.microsoft.com/scripting/powertip-start-hidden-process-with-powershell/
#>

# Parameters to launch the .ps1 script from a command line
Param (
    [String]$Global:ROMAndState = (Read-Host "Please input ROM and save state.")
)

# Define good/bad exit codes and other relevant variables
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Start MAME"
$Global:ExePath = 'C:\pegasus\games\ddr573-mame\'
$Global:Exe = 'mame.exe'
$Global:IniPath = '-inipath C:\pegasus\games\ddr573-mame\'

# Overarching Try block for execution
Try {
    # Change the working directory to the directory with MAME in it, does not parse well without it    
    Set-Location -Path $Global:ExePath
    
    # Create our function for launching MAME with the appropriate ROM and state
    Function Start-MAME($Global:ROMAndState) {
        Start-Process -FilePath "$($Global:ExePath)\$($Global:Exe)" -ArgumentList "$($Global:IniPath) $($Global:ROMAndState)"
    }

    # Start MAME.exe
    Write-Output "Cabinet: Launching MAME.exe with $($Global:ROMAndState)..."
    Start-MAME ($Global:ROMAndState)
    Write-Output "Cabinet: launched MAME.exe."

    # Clean exit
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}