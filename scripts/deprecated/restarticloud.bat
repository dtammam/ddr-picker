GOTO comment

Kill iCloud services, wait 3 seconds and then restart them.
Will plan to run this every few minutes to alleviate sync inconsistencies with the screenshot button. Apparently iCloud for Windows just sucks and this is a known thing.

:comment

@ECHO OFF

:loop

taskkill /f /im iCloudServices.exe
taskkill /f /im iCloudPhotos.exe
timeout /t 3 /nobreak

Start C:\"Program Files (x86)"\"Common Files"\Apple\"Internet Services"\iCloudServices.exe
timeout /t 1 /nobreak
Start C:\"Program Files (x86)"\"Common Files"\Apple\"Internet Services"\iCloudPhotos.exe

timeout /t 360 /nobreak

del C:\Users\me\Pictures\Uploads\*.* /Q

goto :loop