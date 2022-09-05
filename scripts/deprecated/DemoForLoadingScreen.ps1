
# loadingscreen.exe program-to-launch image-to-display timeout-in-milliseconds

$ExePath = 'C:\pegasus\scripts\exe'
$Exe = 'loadingscreen.exe'

$ProgramToLaunch = 'C:\pegasus\games\ddr573-mame\ddrmax.exe'
$ImageToDisplay = 'C:\pegasus\config\metafiles\assets\ddrmax.png'
$TimeoutInMilliseconds = 1234

"$($ExePath)\$($Exe)" $ProgramToLaunch $ImageToDisplay $TimeoutInMilliseconds