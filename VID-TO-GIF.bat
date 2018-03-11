@echo off

REM - Startup info...

echo ~/~    FFMPEG VID-TO-GIF v1.3 by Graham Sider    ~/~
echo ~/~    This program will convert any video file to a 30fps GIF    ~/~
echo ~/~    PLEASE NOTE: In order to use this program, FFMPEG must be properly installed    ~/~
echo ~/~    Visit https://www.ffmpeg.org/ for more information    ~/~
echo.

REM - Conversion

:GETDIR
set /p inputDir="Enter input file path and extension (e.g. input.mp4, C:\dir_path\input.mkv, etc): "
echo.

IF NOT EXIST %inputDir% (
	echo ~/~    ERROR -- File not found    ~/~
	echo.
	GOTO GETDIR
)

set /p outputDir="Enter output file path (e.g. output, C:\dir_path\output, etc -- file extension not needed [will be ".gif"]): "
echo.

echo ~/~    NOTE: larger scaling or a higher framerate will result in a larger file size    ~/~
echo.

set /p width="Enter desired scale of output (via width in pixels -- e.g. 1920, 1280, etc. [input "-1" for no scaling]): "
echo.

set /p fps="Enter desired framerate of output (e.g. 60, 30, 24, etc.): "
echo.

echo ~/~    CREATING TEMPORARY PALETTE    ~/~
echo.
ffmpeg -y -i %inputDir% -vf fps=%fps%,scale=%width%:-1:flags=lanczos,palettegen %TEMP%/palette.png
echo.

REM - Error checking...

IF %ERRORLEVEL% NEQ 0 (
 	echo ~/~    ERROR -- Exiting...    ~/~
 	echo.
 	pause
	exit
)

REM - No error found...

echo ~/~    PALETTE CREATION SUCCESSFUL    ~/~
echo.
pause

echo ~/~    CREATING OUTPUT GIF    ~/~
echo.
ffmpeg -y -i %inputDir% -i %TEMP%/palette.png -filter_complex "fps=%fps%,scale=%width%:-1:flags=lanczos[x];[x][1:v]paletteuse" %outputDir%.gif
echo.

rm %TEMP%/palette.png
echo ~/~    GIF CREATION SUCCESSFUL    ~/~

:CONVERTCOMPLETE
echo.
set /p newFile="Convert another file? (y/n): "
echo.

IF %newFile%==y GOTO GETDIR
IF %newFile%==n (
	echo ~/~    Exiting...    ~/~
	echo.
	pause
	exit
)

echo ~/~    Invalid input...    ~/~
GOTO CONVERTCOMPLETE