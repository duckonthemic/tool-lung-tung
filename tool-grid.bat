@echo off
setlocal

:: Store the name of the current .bat file to exclude it from sorting
set "current_bat=%~nx0"
set "logfile=%~dp0log.txt"

:: Delete old log (if exists) and create a new log file
echo *** Sorting Log - %date% %time% *** > "%logfile%"

:: Create folders if they don't already exist
mkdir "Document"
mkdir "Img"
mkdir "Exe-F"
mkdir "Sound"
mkdir "Zipped"
mkdir "Non-detect"

:: Display start message
echo Starting file sorting... Please wait.
set /a doc_count=0 & set /a img_count=0 & set /a exe_count=0 & set /a sound_count=0 & set /a zipped_count=0 & set /a non_detect_count=0

:: Simple loading animation
call :loading_animation & echo.

:: Move document files
for %%f in (*.txt *.pdf *.doc *.docx *.xls *.xlsx *.ppt *.pptx) do (
    if /i not "%%~nxf"=="%current_bat%" move /Y "%%f" "Document" >nul 2>&1 && set /a doc_count+=1
)

:: Move image files
for %%f in (*.jpg *.jpeg *.png *.gif *.bmp *.tif *.tiff) do (
    if /i not "%%~nxf"=="%current_bat%" move /Y "%%f" "Img" >nul 2>&1 && set /a img_count+=1
)

:: Move executable files
for %%f in (*.exe *.cmd *.msi) do (
    if /i not "%%~nxf"=="%current_bat%" move /Y "%%f" "Exe-F" >nul 2>&1 && set /a exe_count+=1
)

:: Move audio files
for %%f in (*.mp3 *.wav *.flac *.aac *.ogg) do (
    if /i not "%%~nxf"=="%current_bat%" move /Y "%%f" "Sound" >nul 2>&1 && set /a sound_count+=1
)

:: Move compressed files
for %%f in (*.zip *.rar *.7z *.tar *.gz) do (
    if /i not "%%~nxf"=="%current_bat%" move /Y "%%f" "Zipped" >nul 2>&1 && set /a zipped_count+=1
)

:: Move unidentified files
for %%f in (*) do (
    if /i not "%%~nxf"=="%current_bat%" (
        if not exist "Document\%%~nxf" (
            if not exist "Img\%%~nxf" (
                if not exist "Exe-F\%%~nxf" (
                    if not exist "Sound\%%~nxf" (
                        if not exist "Zipped\%%~nxf" (
                            move /Y "%%f" "Non-detect" >nul 2>&1 && set /a non_detect_count+=1
                        )
                    )
                )
            )
        )
    )
)

:: Log results
echo Documents: %doc_count% >> "%logfile%"
echo Images: %img_count% >> "%logfile%"
echo Executables: %exe_count% >> "%logfile%"
echo Audio files: %sound_count% >> "%logfile%"
echo Compressed files: %zipped_count% >> "%logfile%"
echo Unidentified files: %non_detect_count% >> "%logfile%"

:: Display results
echo.
echo ---------------------
echo Sorting complete!
echo Documents: %doc_count%
echo Images: %img_count%
echo Executables: %exe_count%
echo Audio files: %sound_count%
echo Compressed files: %zipped_count%
echo Unidentified files: %non_detect_count%
echo ---------------------
echo Log saved to log.txt
echo.

:: Play completion sound (if supported)
echo ^G

pause
exit

:: Loading animation function
:loading_animation
setlocal enabledelayedexpansion
for /l %%i in (1,1,3) do (
    set /p "=Sorting files." <nul
    ping -n 2 localhost >nul
    set /p "=." <nul
    ping -n 2 localhost >nul
    set /p "=." <nul
    ping -n 2 localhost >nul
    echo.
)
exit /b
