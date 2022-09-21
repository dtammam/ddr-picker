# DDR Picker
DDR Picker is a project started by [Evan Clue](https://github.com/evanclue) who is an awesome [artist](https://clue.graphics/) and [content creator](https://www.youtube.com/c/KKClue). I personally found out about the project incidentally, fell in love with it, got in touch with Evan and have been continuously improving it and learning more about coding as a result. Here's a brief video:

https://user-images.githubusercontent.com/75964108/189134972-04609e77-43ae-49ae-8da0-9a018fbe5106.MOV

## Context
Evan did a fantastic job in documenting the original purpose, context and limitations which you can read in the [original readme](https://github.com/evanclue/ddr-picker/blob/main/README.md). 
The purpose of this specific repo is for my ongoing active development with new feature additions and code modifications over time - once enough change has happened and it's been greenlit, Evan and I will merge projects, readmes and documentation. Some of my goals are below:

## Goals
Below are some of the elements that I'm focusing on, essentially things that differenciate this fork from the primary project that Evan is managing:

- Add new features as inspiration lends itself to myself and Evan
- Modernize the codebase by figuring out how to completely eliminate all needs for .ahk and .bat files, opting for .ps1 and .py (9/21/2022 - We're modern! No more .bat, .ahk or .vbs...)
- Make the UI completely seamless so that no consoles or prompts are visible (9/21/2022 - Very close! We're almost done with all...)
- Make it feel like a utility machine instead of a Windows computer (9/21/2022 - Very close with kiosk mode!)
- Simplify the setup process by providing ways for people to input their keyboard inputs and file paths in a simple, non-technical way over time
- Spread the word throughout the community so folks with similar setups can be aware of this awesome UI

## Prerequisites
Before even starting, please review the [original readme](https://github.com/evanclue/ddr-picker/blob/main/README.md) to ensure that this is something you're interested in setting up. This is an incredibly manual type of thing which will require some intermediate computer skills (such as editing script files and understanding file locations). However, once it's all said and done its' incredibly gratifying and a very cool user experience.

0. Curiosity and interest to spend some time making an awesome setup
1. Interest in learning about [AutoIT](https://www.autoitscript.com/site/)
2. DDR cabinet with a Windows-based PC
3. Installed [LIT board](https://dinsfire.com/projects/lit-board/)
4. Installed JAMMA converter such as a [J-PAC](https://www.ultimarc.com/control-interfaces/j-pac-en/j-pac-c-control-only-version/)
5. Bemani MAME with games ( can be found [here](https://drive.google.com/file/d/1MeW7KpsYcS2fmws7ZQG0OomuIFVHAcid/view?usp=sharing), [here](https://mega.nz/file/ICVRFJwI#ksriX9qHzXEdDwwjsqYv84MN1V43CSedjK8lEosV_7Y) or [here](https://archive.org/download/ddr573-mame/ddr573-mame.zip), 
6. This entire project downloaded in a .zip

## Installation
1. Create a `pegasus` directory in your `C:\` drive and extract the .zip of this project inside of it 
2. From the Bemani MAME download, copy `MAME.exe` into `C:\pegasus\games\ddr573-mame`
3. From the Bemani MAME download, copy the `roms` directory `C:\pegasus\games\ddr573-mame`
4. Review the .ahk scripts in `C:\pegasus\games\ddr573-mame\scripts`. Test them out!
5. Review the .ahk scripts in `C:\pegasus\games\stepmania` and update any references to point to your StepMania-based games
6. Review the .au3 scripts in `C:\pegasus\scripts\au3` to alter any key-based shortcuts for the functions listed, you can then recompile as .exe using SCitE.
7. [Setup MAME controls](https://github.com/evanclue/ddr-picker#setting-up-controls-in-mame).

## Usage
Once you've got it working, there are quite a few cool features I've added which you can leverage. These are mostly represented within `C:\pegasus\scripts` and include:

- A way to go from regular PC mode to a kiosk-style mode (`RegistryUpdatePCToKiosk.ps1`)
- A way to go from kiosk-style to a regular PC mode (`RegistryUpdateKioskToPC.ps1`)
- A way to reset the Litboard lights after closing a game (`ResetLitboardLights.ps1`)
- A single-button press for restarting the computer (`RestartComputer.ps1`)
- A way to take screenshots and upload to iCloud seamlessly (`RestartiCloudLoop.ps1`)
- A way to easily add more MAME games and call them via PowerShell (`StartMAME.ps1`)

## Conclusion
If you've gotten this far (and have actually leveraged my project in any way)... thanks! I've been having a lot of fun working on this with Evan and find thi to be such a cool way to not only make an awesome experience for a cabinet, but continue learning and becoming a better technologist. If someone is able to consume this and enjoy it for regular use, it'd be extremely gratifying.
