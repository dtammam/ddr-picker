# ddr-picker

ddr-picker is a is a [pegasus-fe](https://pegasus-frontend.org/)-based game frontend for Dance Dance Revolution cabinets.
It was originally created by [evanclue](https://github.com/evanclue/ddr-picker) and has been rewritten by myself in an effort to modernize the codebase and add new functionality.

https://user-images.githubusercontent.com/75964108/222937405-d089f0f8-5f87-4cc6-bd3b-9d1dd49c3043.mp4

## Abstract
- Private DDR machines are cool. 
- Purpose-built computers are cool.
- Let's combine those two things together to make a slick DDR multi-game setup.

## Installation

### Preparation
1. Download this repo and place inside a directory named `C:\pegasus`.
2. Create a new directory named `C:\Games` and move any of your games into it.
3. Install [bemani-mame](https://archive.org/download/ddr573-mame/ddr573-mame.zip) if you're intending on using with 573-based games by downloading and placing in `C:\pegasus\games\ddr573-mame\roms`.
4. Install [AutoIT and SCiTE](https://www.autoitscript.com/site/autoit/downloads/). Additionally, I'd recommend installing [VSCode](https://code.visualstudio.com/download) and the AutoIT extension for it once its' installed.

### Initial Configuration
1. Test `C:\pegasus\pegasus-fe.exe` to see if it launches. It should launch with a set of games that are most likely not actually functional. If this is the case, good!
2. Go to `C:\pegasus\config\metafiles` and open/review the metafiles inside:

```
C:\pegasus\config\metafiles\ddr.metadata.pegasus.txt
C:\pegasus\config\metafiles\itg.metadata.pegasus.txt
C:\pegasus\config\metafiles\dancingstage.metadata.pegasus.txt
```

These files each represent a different page within Pegasus, which are sorted by gametype (DDR/ITG/DS). They contain the pointers (images) visible in Pegasus (from `C:\pegasus\config\metafiles\assets` that point to the executables (which you've now got in `C:\Games`) that launch the games. Add/remove/delete any of the pointers as you see fit, then re-launch Pegasus and test that they actually work.

An example scenario would be if you were to have ITGMania setup in C:\Games:

```
collection: In The Groove
shortname: ITG

game: ITGMania
file: C:\pegasus\games\stepmania\StartITGMania.exe
sortBy: a
launch: {file.path}
assets.box_front: assets/simplylove.png

```

You're probably thinking, what's StartITGMania.exe/why are we not pointing to it in `C:\Games`? Good question!

### Setup the Pointer Executables
Pegasus is great but has issues dealing with spaces in paths and generally doesn't play well with straight executables. With AutoIT, we'll be creating our own .exe's that open the games - it plays very nicely with Pegasus.

1. Review my scripts in either `C:\pegasus\games\stepmania\scripts` or `C:\pegasus\games\ddr573-mame\scripts\au3` in VSCode. For our example, open `C:\pegasus\games\stepmania\scripts\StartITGMania.au3`.
2. Update the line where we are running the actual game executable. In this script, it is literally the last line:

```autoit
;~ 	StartITGMania.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant ROM on launch from the frontend. It'll close the frontend launcher, start the relevant prerequisite apps, and hten launch the game via PowerShell script.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.
;~
;~ 	Version:
;~ 		9/20/2022 - Original version.

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Kill Pegasus.
Run("powershell.exe -WindowStyle Hidden -File C:\pegasus\scripts\KillPegasus.ps1", "", @SW_HIDE)

; Launch the game of choice with the correct working directory.
FileChangeDir("C:\Games\ITGmania 0.5.1\Program")
Run('C:\Games\ITGmania 0.5.1\Program\ITGmania.exe', "")
```

3. Once you've updated the script... press F7 to compile it as an .exe file. This will make it so that you can launch it.
4. Save the new .exe file in `C:\pegasus\games\stepmania`. So for example it'll be `C:\pegasus\games\stepmania\scripts\StartITGMania.au3`
5. Go back to `C:\pegasus\config\metafiles\itg.metadata.pegasus.txt` and make sure the pointer now references the correct .exe file and location. Remember - no spaces allowed in the name or pegasus gets confused!
6. Rinse and repeat for any and all executables.

### Kiosk Mode
At this point... you more or less have the setup complete. You launch Pegasus, your game opens, yay. But we can also take it to the next level by setting up what I call Kiosk mode.

#### Autologin
For this to work you need to set your computer to autologin:
1. Open `regedit` as Admin
2. Go to the following path: `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon`
3. Create these keys:
```
Name - Type - Data
AutoAdminLogon - REG_SZ - 1
DefaultPassword - REG_SZ - *The computer password*
DefaultUserName - REG_SZ - *The computer username*
```
4. Restart your computer and make sure that the computer automatically logs in without you needing to do anything.

#### Audio Switch
Our Kiosk mode wont' have access to the built-in audio controls for muting or changing volume so you'll need a small utility for it.
1. Download [AudioSwitch](https://github.com/sirWest/AudioSwitch) and install it.
2. Open it and on the `General` tab enable `Show OSD`
3. On the `Hot Keys` tab map the following functions:

```
Function - Show OSD - Hot Key
TogglePlaybackMute - Checked - VolumeMute
Playback VolumeDown - Checked - VolumeDown
PlaybackVolumeUp - Checked - VolumeUp
```
4. Select `Apply Hotkeys & Close`.
5. Test by pressing VolumeUp and VolumeDown with your keyboard and confirm that you see a little GUI in the top-left showing the volume being changed.

#### Kiosk Mode/PC Mode Scripts
We're going to consider you being on your desktop `PC Mode` and you being on a machine just running pegasus `Kiosk Mode`. To switch between, we're going to be running a script that changes the relevant registry keys. Check out these scripts:

```
"C:\pegasus\scripts\RegistryUpdateKioskToPC.ps1"
"C:\pegasus\scripts\RegistryUpdatePCToKiosk.ps1"
```

Much like pegasus liking .exe's, the startup folder will like .exe's better than PowerShell scripts. So I've created two AutoIT scripts and compiled them as .exe's to launch these scripts via button press. They immediately change the registry key as-needed and then reboot to have it take effect:

```
"C:\pegasus\scripts\au3\F2-RegistryUpdateKioskToPC.au3"
"C:\pegasus\scripts\au3\F3-RegistryUpdatePCToKiosk.au3"
```

Once compiled, I save the .exe's here:
```
"C:\pegasus\F2-RegistryUpdateKioskToPC.exe"
"C:\pegasus\F3-RegistryUpdatePCToKiosk.exe"

```

To explain why we need to do any of this...
- `"C:\pegasus\F2-RegistryUpdateKioskToPC.exe"` will set the registry value `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell` to be `explorer.exe` which is how Windows normally works - it's the default Windows shell.
- `"C:\pegasus\F3-RegistryUpdatePCToKiosk.exe"` will set the registry value `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell` to be a compiled AutoIT script that starts up a bunch of utility apps and pegasus.

Here's `C:\pegasus\scripts\RegistryUpdatePCToKiosk.ps1` which is the script that actually changes the registry key:

```powershell
<#
RegistryUpdatePCToKiosk.ps1

    Goal:
        The purpose of this script is to bring a computer out of PC mode and into kiosk mode.
        This will allow someone to use their utility machine without the annoyance of explorer.exe.

    Audience:
        People who want to be able to optimize front-end usage of Windows-based utility machines.

    Version:
        8/27/2022 - Original version
        9/2/2022 - Conversion from .bat/.reg to .ps1

    Return Codes:
        Success - 0
        Failure - 1

    References:
        Modifying registry via Powershell - https://devblogs.microsoft.com/powershell-community/how-to-update-or-add-a-registry-key-value-with-powershell/
        Microsoft documentation for New-ItemProperty - https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.management/new-itemproperty?view=powershell-7.2
#>

# Define good/bad exit codes
$SuccessExitCode = 0
$FailureExitCode = 1
$Host.UI.RawUI.WindowTitle = "Registry Update PC to Kiosk"

# Overarching Try block for execution
Try {
    Write-Output "Cabinet: Creating variables."
    $RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    $Name = 'Shell'
	$Value = '"C:\pegasus\StartFrontendApps.exe"'
    
    Write-Output "Cabinet: Setting $($Name) to $($Value)..."
    New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType String -Force
    Write-Output "Cabinet: Modified $($Name) to $($Value)."

    Write-Output "Cabinet: Restarting Computer now..."
    Restart-Computer
    Exit $SuccessExitCode
}

# Overarching Catch block for issues
Catch {
    Write-Output "Script failed with the following exception: $($_)"
    Exit $FailureExitCode
}
```

Here's `C:\pegasus\scripts\au3\StartFrontendApps.au3` which is compiled to the .exe which is set in that registry key by the PowerShell script above:
```autoit
;~ 	StartFrontendApps.au3
;~
;~ 	Goal:
;~		The purpose of this .au3 is to launch the relevant applications when the system starts. This will replace explorer.exe as the shell.
;~
;~ 	Audience:
;~ 		People who want to be able to launch scripts on startup.
;~
;~ 	Version:
;~ 		9/20/2022 - Original version.
;~ 		10/23/2022 -  - Migration to nircmd.exe for improved screenshot resolution (Plus-Get-Screenshot.exe and Slash-Get-Screenshot.exe)

; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
#include <WinAPIFiles.au3>
_WinAPI_Wow64EnableWow64FsRedirection(False)

; Launch relevant PowerShell scripts.
Run("powershell.exe -WindowStyle Hidden -File C:\Pegasus\scripts\StartBackendApps.ps1", "", @SW_HIDE)
Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\RestartiCloudLoop.ps1", "", @SW_HIDE)

; Launch relevant apps.
Run("C:\pegasus\Plus-Get-Screenshot.exe")
Run("C:\pegasus\Slash-Get-Screenshot.exe")
Run("C:\pegasus\ControlSpacebar-KillAllAndResetPegasus.exe")
Run("C:\pegasus\Tilde-RestartComputer.exe")
Run("C:\pegasus\F2-RegistryUpdateKioskToPC.exe")
Run("C:\pegasus\F3-RegistryUpdatePCToKiosk.exe")

; Sleep to let the VPN connect.
Sleep(4000)

; Launch Pegasus.
Run("C:\pegasus\pegasus-fe.exe")

```
You can read the script and each script it calls to get an idea of exactly what it's doing. The gist is:

- Starts any backend apps that we care about
- Lets us press F2/F3 to switch modes from Kiosk to PC/PC to Kiosk
- Lets us press ` to restart the computer
- Lets us press Ctrl + Spacebar to close everything and reset Pegasus
- Starts Pegasus for the first time

#### Startup Apps
We're going to make this a utility machine which means most basic stuff won't startup since we won't be launching `explorer.exe` on login. In Kiosk mode, the only thing that starts on login is `C:\pegasus\StartFrontendApps.exe` and the apps it calls. Let's make other things that matter startup:
1. Create a shortcut for `AudioSwitch.exe` and save it in 
`C:\Users\me\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
2. Create a shortcut for `F2-RegistryUpdateKioskToPC.exe` in `C:\Users\me\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
3. Create a shortcut for `F3-RegistryUpdatePCToKiosk.exe` in `C:\Users\me\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

### Optional Elements
If you got this far, you now have a pretty awesome kiosk style utility machine that lets you run your DDR machine like a boss, quickly switching between mixes with a crisp and fast UI. There are things I've left in the repo which you may or may not find useful or want to use:
- `C:\pegasus\scripts\au3\Plus-Get-Screenshot.au3`/`C:\pegasus\scripts\au3\Slash-Get-Screenshot.au3` and `C:\pegasus\scripts\Get-Screenshot.ps1` - A combination of scripts that lets you programmatically take screenshots with a mapped key.
- `C:\pegasus\scripts\StartLitForMAME.ps1` - A way to enable your Litboard-powered lights for the 573-MAME games.
- `C:\pegasus\scripts\RestartiCloudLoop.ps1` - A way to make iCloud photo uploads actually work.
- `C:\pegasus\scripts\StartMAME.ps1` - A way to programmatically launch MAME games consistently.

## Contributing
Pull requests are welcome - just reachout! This was a carefully crafted setup and a lot of thought went into it, I'd love to see where you're taking it.
For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://github.com/dtammam/ddr-picker/blob/main/license.txt)
