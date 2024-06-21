function Connect-VPN {
    <#
    .SYNOPSIS
        Connects your VPN.
    .NOTES
        Connect to a VPN in a programmatic and clean way.
    #>

    [CmdletBinding()]
    param (
        [string]$vpnApplicationDirectory = 'C:\Program Files\OpenVPN\bin',
        [string]$vpnApplication = 'openvpn-gui.exe',
        [string]$vpnProcess = 'openvpn',
        [string]$vpnConfigProfile = 'gradius-DRDOOFUS-phaseii-config.ovpn',
        [int]$secondsToWait = 10
    )

    # Import core modules relevant for all scripts
    [string]$coreFunctionsModule = "$PSScriptRoot\CoreFunctions.psm1"
    Import-Module -Name $coreFunctionsModule -Force

    # Variable declaration
    [string]$vpnApplicationPath = "$vpnApplicationDirectory\$vpnApplication"

    try {
        Open-Header

        Write-Log "Initiating VPN [$($vpnApplication)] using config [$($vpnConfigProfile)]..."
        $vpnProcessStart = Start-Process -FilePath $vpnApplicationPath -ArgumentList "--connect `"$vpnConfigProfile`""

        Write-Log "Waiting for [$($secondsToWait)] seconds before checking the VPN process..."
        Start-Sleep -Seconds $secondsToWait
        $vpnProcessIsRunning = Get-Process -Name $vpnProcess -ErrorAction SilentlyContinue

        if ($null -eq $vpnProcessIsRunning) { throw "The VPN process [$($vpnProcess)] is not running." }
        Write-Output "Validated that the VPN process [$($vpnProcess)] is running!"
        
        $Script:exitCode = 0
    } catch {
        Write-Log "Script failed with the following exception: [$($_.Exception.Message)]"
        $Script:exitCode = 1
    } finally {
        exit $Script:exitCode
    }
}

Connect-VPN