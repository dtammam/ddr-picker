
# ddr-picker

ddr-picker is a [pegasus-fe](https://pegasus-frontend.org/)-based game frontend for Dance Dance Revolution cabinets. It was originally created by [evanclue](https://github.com/evanclue/ddr-picker) and has been rewritten by myself to modernize the codebase and add new functionality.

![Demo Video](https://user-images.githubusercontent.com/75964108/222937405-d089f0f8-5f87-4cc6-bd3b-9d1dd49c3043.mp4)

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Steps](#steps)
- [Configuration](#configuration)
  - [Initial Setup](#initial-setup)
  - [Creating Pointer Executables](#creating-pointer-executables)
- [Kiosk Mode](#kiosk-mode)
  - [Autologin](#autologin)
  - [Audio Switch](#audio-switch)
  - [Scripts for Switching Modes](#scripts-for-switching-modes)
  - [Explanation of Startup Scripts](#explanation-of-startup-scripts)
  - [Startup Apps](#startup-apps)
- [Optional Elements](#optional-elements)
- [Contributing](#contributing)
- [License](#license)

## Introduction
Private DDR machines are cool. Purpose-built computers are cool. Let's combine those two things together to make a slick DDR multi-game setup using ddr-picker.

## Features
- Modernized codebase
- Improved functionality and user experience
- Easy integration with various DDR games
- Makes your PC behave like a 'kiosk'/arcade machine

## Installation

### Prerequisites
1. Ensure that you have administrative access to a Windows PC.
2. Download this repo and place it inside a directory named `C:\pegasus`.
3. Create a new directory named `C:\Games` and move any of your games into it.
4. Install [bemani-mame](https://archive.org/download/ddr573-mame/ddr573-mame.zip) for 573-based games by downloading and placing it in `C:\pegasus\games\ddr573-mame\roms`.
5. Install [AutoIT and SCiTE](https://www.autoitscript.com/site/autoit/downloads/). Additionally, install [VSCode](https://code.visualstudio.com/download) and the AutoIT extension for it.

### Steps
1. Open PowerShell as admin and run the following command to allow key PowerShell scripts to launch:
   ```powershell
   Set-ExecutionPolicy Bypass -Force
   ```
2. Allow the .exe files within this process to be permitted by Windows Defender. These files are compiled AutoIT .au3 files which you can review in this repo.

### Initial Configuration
Pegasus works by mapping pictures to executables. You'll need to setup these mappings to be able to pick and launch the came you'd like.


1. Test `C:\pegasus\pegasus-fe.exe` to see if it launches. It should open with a set of non-functional games.
2. Review and edit the metafiles in `C:\pegasus\config\metafiles`:
   ```text
   C:\pegasus\config\metafiles\ddr.metadata.pegasus.txt
   C:\pegasus\config\metafiles\itg.metadata.pegasus.txt
   C:\pegasus\config\metafiles\dancingstage.metadata.pegasus.txt
   ```
3. Customize the pointers to match your game setup. For example:
   ```text
   collection: In The Groove
   shortname: ITG

   game: ITGMania
   file: C:\pegasus\games\stepmania\StartITGMania.exe
   sortBy: a
   launch: {file.path}
   assets.box_front: assets/simplylove.png
   ```

These files each represent a different page within Pegasus, which are sorted by gametype (DDR/ITG/DS). They contain the pointers (images) visible in Pegasus (from `C:\pegasus\config\metafiles\assets`) that point to the executables (which you've now got in `C:\Games`) 

### Creating Pointer Executables
Pegasus has issues dealing with spaces in paths and generally doesn't play well with executables. With AutoIT, we'll be creating our own .exe's that open the games.

1. Review and update the AutoIT scripts in `C:\pegasus\games\stepmania\scripts` or `C:\pegasus\games\ddr573-mame\scripts\au3`. You can basically get away with just updating the last line.
2. Compile the script by pressing F7 in VSCode and save the .exe file in `C:\pegasus\games\stepmania`.

## Kiosk Mode
At this point you have a function setup (you launch Pegasus, your game opens). But we can also take it to the next level by setting up what I call Kiosk mode which makes your experience closer to that of a dedicated arcade machine.

### Autologin
Enable the machine to power on and work by setting up autologin.

1. Open `regedit` as Admin.
2. Go to `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon` and create the following keys:
   ```text
   Name - Type - Data
   AutoAdminLogon - REG_SZ - 1
   DefaultPassword - REG_SZ - *Your computer password*
   DefaultUserName - REG_SZ - *Your computer username*
   ```
3. Restart your computer to enable autologin.

### Audio Switch
Since `explorer.exe` isn't our shell, the volume mixer won't work. You'll need a small utility for it.

1. Download and install [AudioSwitch](https://github.com/sirWest/AudioSwitch).
2. Enable `Show OSD` in the `General` tab.
3. Map the following hotkeys in the `Hot Keys` tab:
   ```text
   Function - Show OSD - Hot Key
   TogglePlaybackMute - Checked - VolumeMute
   PlaybackVolumeDown - Checked - VolumeDown
   PlaybackVolumeUp - Checked - VolumeUp
   ```

### Scripts for Switching Modes
We're going to consider you being on your desktop `PC Mode` and you being on a machine just running pegasus `Kiosk Mode`. `"C:\pegasus\F2-RegistryUpdateKioskToPC.exe"` will set the registry value `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell` to be `explorer.exe` which is how Windows normally works - it's the default Windows shell.
`"C:\pegasus\F3-RegistryUpdatePCToKiosk.exe"` will set the registry value `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell` to be a compiled AutoIT script that starts up a bunch of utility apps and pegasus.

1. Use `RegistryUpdateKioskToPC.ps1` and `RegistryUpdatePCToKiosk.ps1` scripts to switch between PC and Kiosk modes.
2. Compile these scripts into .exe files using AutoIT and save them in `C:\pegasus`.

### Explanation of Startup Scripts
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

- It is launched on system startup instead of `explorer.exe`
- It starts any backend apps that we care about
- It lets us press `F2`/`F3` to switch modes from Kiosk to PC/PC to Kiosk
- It lets us press `backtic` to restart the computer
- It lets us press `Ctrl + Spacebar` to close everything and reset Pegasus
- It starts Pegasus for the first time


### Startup Apps
When in `Kiosk mode,` most standard things won't startup since we won't be launching `explorer.exe` on login. The only thing that starts on login is `C:\pegasus\StartFrontendApps.exe` and the apps that it calls. To ensure other apps launch, we'll need some shortcuts.

1. Create a shortcut for `AudioSwitch.exe` and save it in 
`C:\Users\*YourUserProfile*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
2. Create a shortcut for `F2-RegistryUpdateKioskToPC.exe` in `C:\Users\*YourUserProfile*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
3. Create a shortcut for `F3-RegistryUpdatePCToKiosk.exe` in `C:\Users\*YourUserProfile*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

## Optional Elements
- `Plus-Get-Screenshot.au3`, `Slash-Get-Screenshot.au3`, and `Get-Screenshot.ps1`: Programmatically take screenshots with a mapped key.
- `StartLitForMAME.ps1`: Enable Litboard-powered lights for 573-MAME games.
- `RestartiCloudLoop.ps1`: Ensure iCloud photo uploads work.
- `StartMAME.ps1`: Consistently launch MAME games.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://github.com/dtammam/ddr-picker/blob/main/license.txt)