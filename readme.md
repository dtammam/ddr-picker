
# ddr-picker

ddr-picker is a [pegasus-fe](https://pegasus-frontend.org/)-based game frontend for Dance Dance Revolution cabinets. It was originally created by [evanclue](https://github.com/evanclue/ddr-picker) and has been rewritten by myself to modernize the codebase, add new functionality and continue evolving the project.



https://github.com/user-attachments/assets/45ce5960-92eb-45ac-bb57-3dfa61056f1c



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
- [Dynamic Marquee](#dynamic-marquee)
   - [Install IrfanView and Configure It](#install-IrfanView-and-configure-it)
   - [Choose the startup and default marquee](#choose-the-startup-and-default-marquee)
   - [Force our reset button to close the marquee and reopen the default](#force-our-reset-button-to-close-the-marquee-and-reopen-the-default)
   - [Update our game launcher executables](#update-our-game-launcher-executables)
   - [Set games to windowed](#set-games-to-windowed)
- [Stream Button](#stream-button)
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
   ```plaintext
   C:\pegasus\config\metafiles\ddr.metadata.pegasus.txt
   C:\pegasus\config\metafiles\itg.metadata.pegasus.txt
   C:\pegasus\config\metafiles\dancingstage.metadata.pegasus.txt
   ```
3. Customize the pointers to match your game setup. For example:
   ```plaintext
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



https://github.com/user-attachments/assets/ae440299-cd6c-43a1-add9-3e25a3174cfe



https://github.com/user-attachments/assets/bbf55bdc-b2d6-4de3-833d-39c6f157cc0e



### Autologin
Enable the machine to power on and work by setting up autologin.

1. Open `regedit` as Admin.
2. Go to `Computer\HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon` and create the following keys:
      ```plaintext
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
      ```plaintext
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
   ; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
   #include <WinAPIFiles.au3>
   _WinAPI_Wow64EnableWow64FsRedirection(False)

   ; Launch relevant PowerShell scripts.
   Run("powershell.exe -WindowStyle Hidden -File C:\Pegasus\scripts\StartBackendApps.ps1", "", @SW_HIDE)
   Run("powershell.exe -WindowStyle Minimized -File C:\Pegasus\scripts\RestartiCloudLoop.ps1", "", @SW_HIDE)

   ; Launch relevant apps.
   Run("C:\pegasus\Plus-GetScreenshot.exe")
   Run("C:\pegasus\Slash-GetScreenshot.exe")
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
- It lets us press ``` ` ``` to restart the computer
- It lets us press `Ctrl + Spacebar` to close everything and reset Pegasus
- It starts Pegasus for the first time


### Startup Apps
When in `Kiosk mode,` most standard things won't startup since we won't be launching `explorer.exe` on login. The only thing that starts on login is `C:\pegasus\StartFrontendApps.exe` and the apps that it calls. To ensure other apps launch, we'll need some shortcuts.

1. Create a shortcut for `AudioSwitch.exe` and save it in 
`C:\Users\*YourUserProfile*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
2. Create a shortcut for `F2-RegistryUpdateKioskToPC.exe` in `C:\Users\*YourUserProfile*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`
3. Create a shortcut for `F3-RegistryUpdatePCToKiosk.exe` in `C:\Users\*YourUserProfile*\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`

## Dynamic Marquee
One of the coolest recent feature additions was a dynamic marquee. The idea came from seeing someone from one of the rhythm game Facebook groups with a monitor and different marquees displayed when they launched different games. It got me excited - I reached out, and they explained that their solution worked but was limited, since it was using wallpapers - wouldn't be compatible with a kiosk-mode as I've got. So I went to work!



https://github.com/user-attachments/assets/f888339c-eae3-4d2e-9dec-84df6d968b0d



The dynamic marquee works by leveraging IrfanView, an excellent image viewer. We're leveraging it with a function within `CoreFunctions.psm1` named `Open-FullscreenImage` which opens an image in fullscreen mode. This function is called by the `SetMarquee.ps1` script which takes a filename as a parameter, then calls the function to open the fullscreen image on our second monitor, which acts as the marquee. 
It's been implemented like this:

### Install IrfanView and configure it
1. Download IrvanView from [their website](https://www.irfanview.com/64bit.htm) (I downloaded and referenced 64-bit, but 32-bit should work. Will just require adjusting the program reference)
2. Open IrfanView and change the following settings:
   1. Options -> Properties/Settings -> Stretch all images to fit screen. Makes the marquee fit the screen fully
   2. Options -> Properties/Settings -> Uncheck the option to display text. Makes it so nothing but the image is displayed on the screen
   3. Open any image file, move it to the marquee monitor so that the coordinates are set and close (not task kill) it. Makes it so that the image you'll open later is launched in fullscreen on the proper monitor

### Choose the startup and default marquee
1. Updated the `StartFrontendApps.au3` file to open an initial marquee (I'm using DDR Supernova's as that was what my cabinet originally was) like this:
   ```autoit
   ; Set the default image for our dynamic marquee.
   Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\ddr-picker-assets\ddr-picker\assets\supernova.png"', "", @SW_HIDE)
   ```
2. Recompile it as an .exe and it'll display the marquee on initial launch.

### Force our reset button to close the marquee and reopen the default
1. Add `'i_view64'` to `KillAllAndResetPegasus.ps1` so that on reset, the currently opened marquee is closed.
2. Add a reference to open the initial marquee like so:
   ```powershell
   Open-FullscreenImage -Image "C:\pegasus\assets\supernova.png" # Match the cabinet by default
   ```

### Update our game launcher executables
1. Go to each of the .au3 files setup for each game that Pegasus launches, and reference the marquee you'd like to use. Below is my `Start-ITGMania.au3` file - check the last three sections for the element that will change between these game-specific files:
   ```autoit
   ;~ 	StartITGmania.au3
   ;~
   ;~ 	Goal:
   ;~		The purpose of this .au3 is to launch the relevant ROM on launch from the frontend. It'll close the frontend launcher, start the relevant prerequisite apps, and then launch the game via PowerShell script.
   ;~
   ;~ 	Audience:
   ;~ 		People who want to be able to launch scripts on startup.
   ;~
   ;~ 	Version:
   ;~ 		2022-09-20 - Original version.
   ;~ 		2024-08-14 - Updating path to new version of ITGmania 0.7.0
   ;~ 		2024-08-14 - Updating path to new version of ITGmania 0.8.0
   ;~ 		2024-07-01 - Standardizing path to more generally refer to a version agnostic ITGmania directory, which will prevent the need to adjust moving forward
   ;~ 		2024-08-10 - Update with reference to asset for digital marquee.
   
   ; Import WinAPI files, ensure that PowerShell launches as a 64-bit instance.
   #include <WinAPIFiles.au3>
   _WinAPI_Wow64EnableWow64FsRedirection(False)
   
   ; Kill Pegasus.
   Run("powershell.exe -WindowStyle Hidden -File C:\pegasus\scripts\KillPegasus.ps1", "", @SW_HIDE)
   
   ; Set the dynamic marquee of choice with the correct working directory.
   FileChangeDir("C:\pegasus\assets")
   Run('powershell.exe -WindowStyle Hidden -File "C:\Pegasus\scripts\SetMarquee.ps1" -Image "C:\pegasus\assets\simply-love.png"', "", @SW_HIDE)
   
   ; Launch the game of choice with the correct working directory.
   FileChangeDir("C:\Games\ITGmania\Program")
   Run('C:\Games\ITGmania\Program\ITGmania.exe', "")   
   ```

2. Recompile it as an .exe, make sure it's saved in a place that your Pegasus `*.metadata.pegasus.txt` files is referencing and it'll launch the fullscreen image alongside your games!

### Set games to windowed
I've learned that setting your games to windowed or borderless windowed leads to the best results. If not, you'll find that the marquee image gets distorted as the resolution changes. To deal with this,
- Spice games: Change to windowed mode with the resolution of your primary monitor.
- MAME games: Natively seems to be running in windowed mode.
- Stepmania games: You can go to the game directory and navigate to `Data\StepMania.ini`, updating the following settings:
   1. DisplayHeight - `DisplayHeight=2160` in my case
   2. DisplayWidth - `DisplayWidth=3840` in my case
   3. Windowed - `Windowed=1`
   - These have worked for me on ITGMania, ITG 1, ITG 2, ITG 3, Mungyodance, NotITG, and even Stepmania 3.9.

## Stream Button
Every so often, I like to stream as I play. This is pretty simple but annoying - I needed to initialize my cameras, then launch OBS, then actually start streaming, adding a few extra clicks to the process. After thinking about it, I figured to make this process as simple as possible.

### Install relevant apps and configure them
1. Download ![OBS](https://obsproject.com/download), configure it as required to get it streaming
2. Install any other relevant software (audio, webcam, etc.)
3. Once done, update `Start-Stream.ps1` with the relevant paths to point to your executables
4. Once done, thanks to `F4-StartStream.exe` you'll be able to press the `F4` key and have your stream start!

## Optional Elements
- `Plus-GetScreenshot.au3`, `Slash-GetScreenshot.au3`, and `Get-Screenshot.ps1`: Programmatically take screenshots with a mapped key which can be uploaded to a cloud storage service like iCloud.

![screenshotSimplyLove](https://github.com/user-attachments/assets/c5dd333a-dd4a-4340-8412-4b19006cd396)
![screenshotOmniMix](https://github.com/user-attachments/assets/c1208f53-9724-4dcb-bc45-ee670a2c2e91)
![screenshotITG2](https://github.com/user-attachments/assets/43a46ebb-ec82-4fd9-b513-fe1b686e4341)
![screenshotDDRMax](https://github.com/user-attachments/assets/f30aff0c-a090-4362-abdf-5e2cc494d81a)


- `StartLitForMAME.ps1`: Enable Litboard-powered lights for 573-MAME games.
- `RestartiCloudLoop.ps1`: Ensure iCloud photo uploads work.

  

https://github.com/user-attachments/assets/84e36592-89f9-400a-8562-5592f942f6c1



- `StartMAME.ps1`: Consistently launch MAME games.

## Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://github.com/dtammam/ddr-picker/blob/main/license.txt)
