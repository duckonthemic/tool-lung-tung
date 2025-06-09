@echo off
:: AutoSort 2.0 – File Organizer & Logger
:: Usage :  autosort.bat  [src]  [dst]  [/copy]  [/quiet]
:: Author : DK & ChatGPT – 09-Jun-2025

:: ---------- 1. Chuẩn bị môi trường ----------
setlocal enableextensions enabledelayedexpansion
set "MYNAME=%~nx0"

:: Xử lý tham số
set "SRC=%~1"
if "%SRC%"=="" set "SRC=%CD%"
if not exist "%SRC%" (
    echo [ERR] Source "%SRC%" not found & exit /b 1
)
pushd "%SRC%" >nul

set "DST=%~2"
if "%DST%"=="" set "DST=%SRC%"

set "MODE=move"
if /i "%~3"=="/copy"    set "MODE=copy"
if /i "%~4"=="/copy"    set "MODE=copy"
if /i "%~3"=="/quiet"   set "QUIET=1"
if /i "%~4"=="/quiet"   set "QUIET=1"

:: File log theo ngày-giờ
for /f %%t in ("%date:~-4%%date:~3,2%%date:~0,2%_%time:~0,2%%time:~3,2%%time:~6,2%") do (
    set "LOG=%DST%\sort_%%t.log"
)

:: ---------- 2. Bảng danh mục ----------
::   cú pháp:  call :addCat "FolderName" "ext1 ext2 ext3"
set "_CAT_COUNT=0"
call :addCat "Document"   "txt doc docx pdf xls xlsx ppt pptx csv odt ods odp"
call :addCat "Image"      "jpg jpeg png gif bmp tif tiff webp svg"
call :addCat "Audio"      "mp3 wav flac aac ogg m4a"
call :addCat "Video"      "mp4 mkv mov avi wmv webm"
call :addCat "Archive"    "zip rar 7z tar gz bz2 iso"
call :addCat "Executable" "exe msi bat cmd ps1"
call :addCat "Script"     "js py rb vbs sh php"
call :addCat "Other"      ""   :: phải đặt cuối

:: ---------- 3. Vòng lặp duy nhất ----------
if not defined QUIET echo Sorting files from "%SRC%" to "%DST%"...
> "%LOG%" (
    echo === AutoSort 2.0  –  %date% %time%
)

for %%F in (*.*) do (
    if /i not "%%~nxF"=="%MYNAME%" (
        set "DESTFOLDER="
        for /l %%I in (1,1,%_CAT_COUNT%) do (
            for %%E in (!CAT%%I_EXT!) do (
                if /i "%%~xF"==".%%E" set "DESTFOLDER=!CAT%%I_DIR!"
            )
        )
        if not defined DESTFOLDER set "DESTFOLDER=!CAT%_CAT_COUNT%_DIR!"  :: Other

        if not exist "%DST%\!DESTFOLDER!" mkdir "%DST%\!DESTFOLDER!" >nul

        %MODE% /y "%%~fF" "%DST%\!DESTFOLDER!\"
        if !ERRORLEVEL! == 0 (
            echo [%%~nxF]  →  !DESTFOLDER!>>"%LOG%"
            set /a CNT!DESTFOLDER!+=1
        )
    )
)

:: ---------- 4. Kết quả ----------
echo.>>"%LOG%"
for /l %%I in (1,1,%_CAT_COUNT%) do (
    call :showCnt !CAT%%I_DIR!
)

if not defined QUIET (
    echo ------------- Summary -------------
    type "%LOG%" | more
    echo Log saved: "%LOG%"
)
popd >nul & endlocal & goto :eof

:: ********** 5. Hàm & Thủ tục **********
:addCat
set /a _CAT_COUNT+=1
set "CAT%_CAT_COUNT%_DIR=%~1"
set "CAT%_CAT_COUNT%_EXT=%~2"
set "CNT%~1=0"
exit /b

:showCnt
set "TMPCNT=!CNT%1!"
if "%TMPCNT%"=="" set "TMPCNT=0"
echo %1: %TMPCNT%>>"%LOG%"
exit /b
