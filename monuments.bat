REM Put this script in "..\steamapps\workshop\content\784150\monuments.bat"
REM You have to launch it once before launching game if you downloaded new decoration mods or older one were updated

@echo off
setlocal enabledelayedexpansion

REM Set the current folder as the active folder
cd /d "%~dp0"

REM Search for "$TYPE_MONUMENT" in building.ini files and output results to results.txt
(for /r %%a in (building.ini) do (
    type "%%a" | find /i "$TYPE_MONUMENT" >nul && (
        echo %%a
    )
)) >results.txt

REM Generate a timestamp for the backup filename
for /f "tokens=1-3 delims=/ " %%A in ('date /t') do (
    set "timestamp=%%A_%%B_%%C"
)

for /f "tokens=1-2 delims=:." %%A in ('time /t') do (
    set "timestamp=!timestamp!_%%A_%%B"
)

REM Process the results.txt file to edit the matching files and create backups
for /f "delims=" %%b in (results.txt) do (
	set /a "linecount+=1"
    set "filename=%%b"
    set "tempfile=!filename!.tmp"

    REM Create a backup of the original building.ini file
    set "backupfile=!filename:.ini=_bak_%timestamp: =%.ini!"
    copy /y "!filename!" "!backupfile!" >nul 2>nul

    REM Delete everything except the line containing "$NAME_STR"
    findstr /i /c:"$NAME_STR" "!filename!" >"!tempfile!"

    REM Add the new lines to the temporary file
    echo.$HARBOR_EXTEND_AREA_WHEN_BULDING -80>>"!tempfile!"
    echo.$TYPE_MONUMENT>>"!tempfile!"
    echo.$IGNORE_COUNT_LIMIT>>"!tempfile!"
    echo.end>>"!tempfile!"

    REM Replace the original file with the modified temporary file
    move /y "!tempfile!" "!filename!" >nul 2>nul
)

REM Output the line count to a variable
set /a "linecount-=1"

REM Remove the results.txt file
del results.txt >nul 2>nul

echo The system finally managed to find all the files specified.
echo. 
echo Task completed successfully regardless of all errors above which you can simply ignore. Everything is good. Trust me. If everything is actually is not good, I've made backups for you.
echo Total of %linecount% files edited.
echo Congrats, %USERNAME%! Seems like everything worked well!
echo.
echo (C)2023 Lex713
pause
