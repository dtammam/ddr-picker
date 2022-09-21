;TestKeyPress
#include <Misc.au3>
#include <MsgBoxConstants.au3>

Local $hDLL = DllOpen("user32.dll")

While 1
        If _IsPressed("A1", $hDLL) Then
                Runwait("powershell.exe C:\pegasus\scripts\KillAllAndResetPegasus.ps1", "", @SW_HIDE)
	Sleep(250)
	EndIf
	
WEnd
DllClose($hDLL)
